import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/addIngredientsToDishScreen.dart';
//import 'package:tb_frontend/models/ingredient.dart';
//import 'package:tb_frontend/screens/dishes/dishIngredientsSelectionScreen.dart';

import '../../dto/ingredientLessDTO.dart';
import '../../models/dish.dart';
import '../../models/ingredient.dart';

class IngredientCheck {
  int id;
  String name;
  bool isChecked;
  double? weight;

  IngredientCheck(this.id, this.name, this.isChecked, {this.weight});
}

class CreateDishScreen extends StatefulWidget {
  final Dish? dish;
  const CreateDishScreen({this.dish, super.key});

  @override
  _CreateDishScreenState createState() => _CreateDishScreenState();
}

class _CreateDishScreenState extends State<CreateDishScreen> {
  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _name = '';
  String? _description;
  String _currentType = '';
  String _currentSize = '';
  double _price = 0.0;
  bool _isAvailable = false;
  int _calories = 0;
  double? _fats;
  double? _saturatedFats;
  double? _sodium;
  double? _carbohydrates;
  double? _fibers;
  double? _sugars;
  double? _proteins;
  double? _calcium;
  double? _iron;
  double? _potassium;

  //TextEditingController nameController = TextEditingController();

  final DishType _selectedDishType = DishType.meat;
  final DishSize _selectedDishSize = DishSize.fit;

  List<IngredientCheck> ingredients = [];
  List<IngredientCheck> selectedIngredients = [];
  List<IngredientLessDTO> ingredientsLessDTO = [];

  @override
  void initState() {
    super.initState();
    _loadIngredients();
    if (widget.dish != null) {
      _id = widget.dish!.id;
      _name = widget.dish!.name;
      _description = widget.dish!.description;
      _currentType = widget.dish!.currentType;
      _currentSize = widget.dish!.currentSize;
      _price = widget.dish!.price;
      _isAvailable = widget.dish!.isAvailable;
      _calories = widget.dish!.calories;
      _fats = widget.dish!.fats;
      _saturatedFats = widget.dish!.saturatedFats;
      _sodium = widget.dish!.sodium;
      _carbohydrates = widget.dish!.carbohydrates;
      _fibers = widget.dish!.fibers;
      _sugars = widget.dish!.sugars;
      _proteins = widget.dish!.proteins;
      _calcium = widget.dish!.calcium;
      _iron = widget.dish!.iron;
      _potassium = widget.dish!.potassium;
      ingredientsLessDTO = widget.dish!.ingredients!;
      selectedIngredients = ingredientsLessDTO
          .map((ingredient) => IngredientCheck(
                ingredient.id,
                ingredient.name,
                true,
                weight: ingredient.weight,
              ))
          .toList();
    }
  }

  void _toggleIngredient(int index, bool value) {
    setState(() {
      ingredients[index].isChecked = value;
    });
  }

  void _onAddPressed() {
    selectedIngredients =
        ingredients.where((ingredient) => ingredient.isChecked).toList();

    // Do something with the selectedIngredients
    print(selectedIngredients);

    // Close the bottom sheet
    Navigator.pop(context);
  }

  void _loadIngredients() async {
    log("========================================== _loadIngredients");
    fetchIngredients().then((value) {
      ingredients.clear();
      setState(() {
        for (var element in value) {
          log("========================================== ${element.name}");
          ingredients.add(IngredientCheck(element.id, element.name, false));
        }
      });
    });
  }

  void _addIngredientsToDish() async {
    log("========================================== _addIngredientsToDish");
    final newIngredients = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddIngredientsToDishScreen(ingredients, selectedIngredients),
      ),
    );
    if (newIngredients != null) {
      setState(() {
        selectedIngredients = newIngredients;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Dish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  //controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter the dish name',
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                  initialValue: _name,
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    hintText: 'Enter the dish price',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  initialValue: _price == 0 ? '' : _price.toString(),
                  onChanged: (value) {
                    setState(() {
                      _price = double.parse(value);
                    });
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Calories',
                    hintText: 'Enter the dish calories',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _calories == 0 ? '' : _calories.toString(),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty) {
                      return 'Please enter a valid number of calories';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _calories = int.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter the dish description',
                  ),
                  initialValue: _description,
                  onChanged: (value) {
                    setState(() {
                      _description = value;
                    });
                  },
                ),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Type', hintText: 'Select the dish type'),
                  value: _currentType == ''
                      ? null
                      : _currentType,
                  onChanged: (value) {
                    setState(() {
                      _currentType = value.toString().toUpperCase();
                    });
                  },
                  items: DishType.values
                      .map(
                        (type) => DropdownMenuItem(
                          value: type.toString() == _currentType
                              ? _currentType
                              : type.name.toString().toUpperCase(),
                          child: Text(type.name.toString().toUpperCase()),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a valid type';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'Size'),
                  value: _currentSize == '' ? null : _currentSize,
                  onChanged: (value) {
                    setState(() {
                      _currentSize = value.toString().toUpperCase();
                    });
                  },
                  items: DishSize.values
                      .map(
                        (size) => DropdownMenuItem(
                          value: size.toString() == _currentSize
                              ? _currentSize
                              : size.name.toString().toUpperCase(),
                          child: Text(size.name.toString().toUpperCase()),
                        ),
                      )
                      .toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a valid size';
                    }
                    return null;
                  },
                ),
                SwitchListTile(
                  title: const Text('Is Available'),
                  value: _isAvailable,
                  onChanged: (value) {
                    setState(() {
                      _isAvailable = value;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                const Text('Nutritional Informations (Optional)'),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fats',
                    hintText: 'Enter the dish fats',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _fats == null ? '' : _fats.toString(),
                  onChanged: (value) {
                    setState(() {
                      _fats = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Saturated Fats',
                    hintText: 'Enter the dish saturated fats',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue:
                      _saturatedFats == null ? '' : _saturatedFats.toString(),
                  onChanged: (value) {
                    setState(() {
                      _saturatedFats = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Sodium',
                    hintText: 'Enter the dish sodium',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _sodium == null ? '' : _sodium.toString(),
                  onChanged: (value) {
                    setState(() {
                      _sodium = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Carbohydrates',
                    hintText: 'Enter the dish carbohydrates',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue:
                      _carbohydrates == null ? '' : _carbohydrates.toString(),
                  onChanged: (value) {
                    setState(() {
                      _carbohydrates = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Fibers',
                    hintText: 'Enter the dish fibers',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _fibers == null ? '' : _fibers.toString(),
                  onChanged: (value) {
                    setState(() {
                      _fibers = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Sugars',
                    hintText: 'Enter the dish sugars',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _sugars = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Proteins',
                    hintText: 'Enter the dish proteins',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _proteins == null ? '' : _proteins.toString(),
                  onChanged: (value) {
                    setState(() {
                      _proteins = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Calcium',
                    hintText: 'Enter the dish calcium',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _calcium == null ? '' : _calcium.toString(),
                  onChanged: (value) {
                    setState(() {
                      _calcium = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Iron',
                    hintText: 'Enter the dish iron',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _iron == null ? '' : _iron.toString(),
                  onChanged: (value) {
                    setState(() {
                      _iron = double.parse(value);
                    });
                  },
                ),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Potassium',
                    hintText: 'Enter the dish potassium',
                  ),
                  keyboardType: TextInputType.number,
                  initialValue: _potassium == null ? '' : _potassium.toString(),
                  onChanged: (value) {
                    setState(() {
                      _potassium = double.parse(value);
                    });
                  },
                ),

                // Add more text fields for other properties here
                const SizedBox(height: 16.0),

                Row(children: [
                  const Text('List of ingredients (Optional) : '),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _addIngredientsToDish();
                    },
                    child: const Text('Add ingredients'),
                  ),
                  const SizedBox(height: 16.0),
                ]),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    child: const Text('Create Dish'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        ingredientsLessDTO = selectedIngredients
                            .map((e) =>
                                IngredientLessDTO(e.id, e.name, e.weight))
                            .toList();
                        // Create an instance of the Dish class using the collected inputs
                        Dish newDish = Dish(
                          id: _id,
                          name: _name,
                          description: _description,
                          currentType: _currentType,
                          currentSize: _currentSize,
                          price: _price,
                          isAvailable: _isAvailable,
                          calories: _calories,
                          fats: _fats,
                          saturatedFats: _saturatedFats,
                          sodium: _sodium,
                          carbohydrates: _carbohydrates,
                          fibers: _fibers,
                          sugars: _sugars,
                          proteins: _proteins,
                          calcium: _calcium,
                          iron: _iron,
                          potassium: _potassium,
                          ingredients: ingredientsLessDTO,
                        );

                        Future<Dish> resultDish;

                        if (widget.dish != null) {
                          resultDish = updateDish(newDish);
                        } else {
                          resultDish = createDish(newDish);
                        }
                        resultDish.whenComplete(
                            () => Navigator.of(context).pop(resultDish));
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
