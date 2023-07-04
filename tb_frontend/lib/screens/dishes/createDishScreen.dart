import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/dish.dart';

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

  final DishType _selectedDishType = DishType.meat;
  final DishSize _selectedDishSize = DishSize.fit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Dish'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              TextFormField(
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
                decoration: InputDecoration(labelText: 'Price'),
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
                decoration: InputDecoration(labelText: 'Calories'),
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
                decoration: InputDecoration(labelText: 'Description (Optional)'),
                onChanged: (value) {
                  setState(() {
                    description = value;
                  });
                },
              ),

              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'Type'),
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
                decoration: InputDecoration(labelText: 'Size'),
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
                title: Text('Is Available'),
                value: isAvailable,
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              Text('Nutritional Informations (Optional)'),

              TextFormField(
                decoration: InputDecoration(labelText: 'Fats'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    fats = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Saturated Fats'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    saturatedFats = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Sodium'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    sodium = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Carbohydrates'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    carbohydrates = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Fibers'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    fibers = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Sugars'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    sugars = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Proteins'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    proteins = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Calcium'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    calcium = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Iron'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    iron = double.parse(value);
                  });
                },
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Potassium'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    potassium = double.parse(value);
                  });
                },
              ),

              // Add more text fields for other properties here
              const SizedBox(height: 16.0),
              ElevatedButton(
                  child: Text('Create Dish'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
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
                      );

                      // Do something with the newDish object, like saving it to a database or passing it to another screen
                      print(newDish);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
