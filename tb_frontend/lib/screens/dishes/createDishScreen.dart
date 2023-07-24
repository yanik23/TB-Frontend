import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/addIngredientsToDishScreen.dart';
import '../../dto/ingredientLessDTO.dart';
import '../../models/dish.dart';
import '../../models/ingredient.dart';
import '../../utils/constants.dart';
import '../welcomeScreen.dart';

class IngredientCheck {
  int id;
  String name;
  bool isChecked;
  double? weight;

  IngredientCheck(this.id, this.name, this.isChecked, {this.weight});
}

class CreateDishScreen extends StatefulWidget {
  final Dish? dish;
  final String title;
  const CreateDishScreen(this.title, {this.dish, super.key});

  @override
  State<CreateDishScreen> createState() => _CreateDishScreenState();
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

  /*final DishType _selectedDishType = DishType.meat;
  final DishSize _selectedDishSize = DishSize.fit;*/

  List<IngredientCheck> ingredients = [];
  List<IngredientCheck> selectedIngredients = [];
  List<IngredientLessDTO> ingredientsLessDTO = [];

  final RegExp _nameRegExp = RegExp(nameRegexPattern);
  final RegExp _descriptionRegExp = RegExp(descriptionRegexPattern);
  final RegExp _intRegExp = RegExp(intRegexPattern);
  final RegExp _doubleRegExp = RegExp(doubleRegexPattern);

  late bool _nutritionInfo;
  late Icon icon;

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
    _nutritionInfo = false;
    icon = Icon(
      Icons.arrow_right,
      color: kColorScheme.primary,
    );
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

    // Close the bottom sheet
    Navigator.pop(context);
  }

  void _loadIngredients() async {
    fetchIngredients().then((value) {
      ingredients.clear();
      setState(() {
        for (var element in value) {
          ingredients.add(IngredientCheck(element.id, element.name, false));
        }
      });
    });
  }

  void _addIngredientsToDish() async {
    log("========================================== _addIngredientsToDish");
    for (var el in selectedIngredients) {
      log("=============selected=========================== ${el.name}");
    }
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
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter the dish name',
                  ),
                  maxLength: 50,
                  initialValue: _name,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty ||
                        !_nameRegExp.hasMatch(value)) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  },
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
                  initialValue: _price == 0 ? '' : _price.toString(),
                  maxLength: 6,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty ||
                        !_doubleRegExp.hasMatch(value)) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
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
                  maxLength: 6,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.trim().isEmpty ||
                        !_intRegExp.hasMatch(value)) {
                      return 'Please enter a valid integer number of calories';
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
                  maxLength: 255,
                  validator: (value) {
                    if (!_descriptionRegExp.hasMatch(value!)) {
                      return 'Please enter a valid description';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      value.isEmpty
                          ? _description = null
                          : _description = value;
                    });
                  },
                ),

                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      labelText: 'Type', hintText: 'Select the dish type'),
                  value: _currentType == '' ? null : _currentType,
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

                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _nutritionInfo = !_nutritionInfo;
                      _nutritionInfo
                          ? icon = Icon(
                              Icons.arrow_drop_down,
                              color: kColorScheme.primary,
                            )
                          : icon = Icon(
                              Icons.arrow_right,
                              color: kColorScheme.primary,
                            );
                    });
                    //icon = Icons.arrow_left
                  },
                  icon: icon,
                  label: Text(
                    'Nutritional Information (Optional)',
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: kColorScheme.primary),
                  ),
                ),
                if (_nutritionInfo)
                  Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fats',
                          hintText: 'Enter the dish fats',
                        ),
                        keyboardType: TextInputType.number,
                        initialValue: _fats == null ? '' : _fats.toString(),
                        maxLength: 10,
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid fats value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _fats = null
                                : _fats = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Saturated Fats',
                          hintText: 'Enter the dish saturated fats',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue: _saturatedFats == null
                            ? ''
                            : _saturatedFats.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid saturated fats value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _saturatedFats = null
                                : _saturatedFats = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Sodium',
                          hintText: 'Enter the dish sodium',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue: _sodium == null ? '' : _sodium.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid sodium value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _sodium = null
                                : _sodium = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Carbohydrates',
                          hintText: 'Enter the dish carbohydrates',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue: _carbohydrates == null
                            ? ''
                            : _carbohydrates.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid carbohydrates value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _carbohydrates = null
                                : _carbohydrates = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Fibers',
                          hintText: 'Enter the dish fibers',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue: _fibers == null ? '' : _fibers.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid fibers value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _fibers = null
                                : _fibers = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Sugars',
                          hintText: 'Enter the dish sugars',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue: _sugars == null ? '' : _sugars.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid sugars value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _sugars = null
                                : _sugars = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Proteins',
                          hintText: 'Enter the dish proteins',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue:
                            _proteins == null ? '' : _proteins.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid proteins value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _proteins = null
                                : _proteins = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Calcium',
                          hintText: 'Enter the dish calcium',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue:
                            _calcium == null ? '' : _calcium.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid calcium value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _calcium = null
                                : _calcium = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Iron',
                          hintText: 'Enter the dish iron',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue: _iron == null ? '' : _iron.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid iron value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _iron = null
                                : _iron = double.parse(value);
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Potassium',
                          hintText: 'Enter the dish potassium',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        initialValue:
                            _potassium == null ? '' : _potassium.toString(),
                        validator: (value) {
                          if (!_doubleRegExp.hasMatch(value!)) {
                            return 'Please enter a valid potassium value';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            value.isEmpty
                                ? _potassium = null
                                : _potassium = double.parse(value);
                          });
                        },
                      ),
                    ],
                  ),

                // Add more text fields for other properties here
                const SizedBox(height: 16.0),

                Row(children: [
                  Text('List of ingredients (Optional) : ', style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    color: kColorScheme.primary,
                  ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      _addIngredientsToDish();
                    },
                    child: const Text('Add ingredients'),
                  ),
                  const SizedBox(height: 16.0),
                ]),

                if(selectedIngredients?.isEmpty ?? true)
                  const Text('N/A'),
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 300.0),
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedIngredients?.length ?? 0,
                      itemBuilder: (context, index) =>
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(selectedIngredients?[index].name ?? 'N/A', style: TextStyle(
                                    fontSize: 18.0,
                                    //fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),),
                                ),
                                const Spacer(),
                                Expanded(
                                  child: Row(
                                    children: [
                                      const Icon(Icons.balance, color: Colors.orangeAccent),
                                      const SizedBox(width: 8.0),
                                      Text(selectedIngredients?[index].weight != null ? '${selectedIngredients?[index].weight}g' : 'N/A'),
                                      //const Spacer(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                    child: const Text('Save Dish'),
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
