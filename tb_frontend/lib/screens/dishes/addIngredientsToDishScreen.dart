



import 'package:flutter/material.dart';

import 'createDishScreen.dart';

class AddIngredientsToDishScreen extends StatefulWidget {
  final List<IngredientCheck> ingredients;

  const AddIngredientsToDishScreen(this.ingredients, {super.key});

  @override
  State<AddIngredientsToDishScreen> createState() => _AddIngredientsToDishScreenState();
}

class _AddIngredientsToDishScreenState extends State<AddIngredientsToDishScreen> {
  List<IngredientCheck> selectedIngredients = [];
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    selectedIngredients = List.from(widget.ingredients);
  }

  void _toggleIngredient(int index, bool value) {
    setState(() {
      selectedIngredients[index].isChecked = value;
    });
  }

  void _onAddPressed() {
    List<IngredientCheck> si =
    selectedIngredients.where((ingredient) => ingredient.isChecked).toList();

    Navigator.pop(context, si);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Ingredients'),
          actions: [
      IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        setState(() {
          _showSearchBar = !_showSearchBar;
        });
      },
    ),
    ]
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: selectedIngredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: <Widget>[
                    CheckboxListTile(
                      title: Text(selectedIngredients[index].name),
                      value: selectedIngredients[index].isChecked,
                      onChanged: (value) {
                        _toggleIngredient(index, value!);
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          selectedIngredients[index].weight = double.parse(value);
                        });
                      },
                    ),
                    const SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
      ),
    );
  }

}