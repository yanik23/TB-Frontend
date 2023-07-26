import 'package:flutter/material.dart';

/*class Ingredient {
  String name;
  bool isChecked;

  Ingredient(this.name, this.isChecked);
}

class IngredientSelectionScreen extends StatefulWidget {
  @override
  _IngredientSelectionScreenState createState() =>
      _IngredientSelectionScreenState();
}

class _IngredientSelectionScreenState extends State<IngredientSelectionScreen> {
  List<Ingredient> ingredients = [
    Ingredient('Ingredient 1', false),
    Ingredient('Ingredient 2', false),
    Ingredient('Ingredient 3', false),
    Ingredient('Ingredient 1', false),
    Ingredient('Ingredient 2', false),
    Ingredient('Ingredient 3', false),
    Ingredient('Ingredient 1', false),
    Ingredient('Ingredient 2', false),
    Ingredient('Ingredient 3', false),
    Ingredient('Ingredient 1', false),
    Ingredient('Ingredient 2', false),
    Ingredient('Ingredient 3', false),
    Ingredient('Ingredient 1', false),
    Ingredient('Ingredient 2', false),
    Ingredient('Ingredient 3', false),
    // Add more ingredients as needed
  ];

  List<Ingredient> selectedIngredients = [];

  void _toggleIngredient(int index, bool value) {
    setState(() {
      ingredients[index].isChecked = value;
    });
  }

  void _onAddPressed() {
    selectedIngredients = ingredients.where((ingredient) => ingredient.isChecked).toList();

    // Do something with the selectedIngredients
    print(selectedIngredients);

    // Close the bottom sheet
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredient Selection'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Column(
                      children: <Widget>[
                        Text('Select Ingredients', style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.primary,)),
                        Expanded(
                          child: ListView.builder(
                            itemCount: ingredients.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                title: Text(ingredients[index].name),
                                value: ingredients[index].isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _toggleIngredient(index, value!);
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: _onAddPressed,
                              child: Text('Add'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
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
          child: Text('Open Modal Bottom Sheet'),
        ),
      ),
    );
  }
}*/