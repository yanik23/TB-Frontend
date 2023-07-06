import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:tb_frontend/models/ingredient.dart';
//import 'package:tb_frontend/screens/dishes/dishIngredientsSelectionScreen.dart';

import '../../dto/ingredientLessDTO.dart';
import '../../models/dish.dart';
import '../../models/ingredient.dart';

class IngredientCheck {
  String name;
  bool isChecked;
  double? weight;

  IngredientCheck(this.name, this.isChecked, {this.weight});
}

class CreateDishScreen extends StatefulWidget {
  const CreateDishScreen({super.key});

  @override
  _CreateDishScreenState createState() => _CreateDishScreenState();
}

class _CreateDishScreenState extends State<CreateDishScreen> {
  final _formKey = GlobalKey<FormState>();
  int id = 0;
  String name = '';
  String? description;
  String currentType = '';
  String currentSize = '';
  double price = 0.0;
  bool isAvailable = false;
  int calories = 0;
  double? fats;
  double? saturatedFats;
  double? sodium;
  double? carbohydrates;
  double? fibers;
  double? sugars;
  double? proteins;
  double? calcium;
  double? iron;
  double? potassium;

  bool? _checked = false;


  TextEditingController nameController = TextEditingController();

  final DishType _selectedDishType = DishType.meat;
  final DishSize _selectedDishSize = DishSize.fit;

  List<IngredientCheck> ingredients = [];
  List<IngredientCheck> selectedIngredients = [];
  List<IngredientLessDTO> ingredientsLessDTO = [];

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
          ingredients.add(IngredientCheck(element.name, false));
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadIngredients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Dish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child : Form(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.always,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  //hintText: 'Enter the name of the dish',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  //log("========================================== {value}");
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid price';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    price = double.parse(value);
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calories'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid number of calories';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    calories = int.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Description (Optional)'),
                /*onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },*/
              ),

              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                //value: _selectedDishType,
                onChanged: (value) {
                  setState(() {
                    currentType = value.toString().toUpperCase();
                  });
                },
                items: DishType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toString().toUpperCase()),
                      ),
                    )
                    .toList(),
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Size'),
                //value: _selectedDishSize,
                onChanged: (value) {
                  setState(() {
                    currentSize = value.toString().toUpperCase();
                  });
                },
                items: DishSize.values
                    .map(
                      (size) => DropdownMenuItem(
                        value: size,
                        child: Text(size.name.toString().toUpperCase()),
                      ),
                    )
                    .toList(),
              ),
              SwitchListTile(
                title: const Text('Is Available'),
                value: isAvailable,
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Nutritional Informations (Optional)'),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Fats'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    fats = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Saturated Fats'),
                keyboardType: TextInputType.number,
                 onChanged: (value) {
                  setState(() {
                    saturatedFats = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Sodium'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    sodium = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Carbohydrates'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    carbohydrates = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Fibers'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    fibers = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Sugars'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    sugars = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Proteins'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    proteins = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Calcium'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    calcium = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Iron'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    iron = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Potassium'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    potassium = double.parse(value);
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
                    log("========================================== button pressed");
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Column(
                              children: <Widget>[
                                Text('Select Ingredients',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    )),
                                Expanded(
                                  child: ListView.builder(
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16.0),
                                    itemCount: ingredients.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(children: <Widget>[
                                        CheckboxListTile(
                                          title: Text(ingredients[index].name),
                                          value: ingredients[index].isChecked,
                                          onChanged: (value) {
                                            setState(() {
                                              _toggleIngredient(index, value!);
                                            });
                                          },
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                              labelText: 'Quantity'),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            setState(() {
                                              ingredients[index].weight = double.parse(value);
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 16.0),
                                      ]);
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed: _onAddPressed,
                                      child: const Text('Add'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
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

                      ingredientsLessDTO = ingredients.map((e) => IngredientLessDTO(e.name, e.weight)).toList();
                      // Create an instance of the Dish class using the collected inputs
                      Dish newDish = Dish(
                        id: id,
                        name: name,
                        description: description,
                        currentType: currentType,
                        currentSize: currentSize,
                        price: price,
                        isAvailable: isAvailable,
                        calories: calories,
                        fats: fats,
                        saturatedFats: saturatedFats,
                        sodium: sodium,
                        carbohydrates: carbohydrates,
                        fibers: fibers,
                        sugars: sugars,
                        proteins: proteins,
                        calcium: calcium,
                        iron: iron,
                        potassium: potassium,
                        ingredients: ingredientsLessDTO,
                      );


                      // Do something with the newDish object, like saving it to a database or passing it to another screen

                      Future<Dish> dish = createDish(newDish);
                      dish.whenComplete(() => Navigator.of(context).pop(dish));

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
