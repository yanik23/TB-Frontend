



import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';

import 'createDishScreen.dart';

class AddIngredientsToDishScreen extends StatefulWidget {
  final List<IngredientCheck> ingredients;
  final List<IngredientCheck> selectedIngredients;

  const AddIngredientsToDishScreen(this.ingredients, this.selectedIngredients, {super.key});

  @override
  State<AddIngredientsToDishScreen> createState() => _AddIngredientsToDishScreenState();
}

class _AddIngredientsToDishScreenState extends State<AddIngredientsToDishScreen> {
  List<IngredientCheck> selectedIngredients = [];
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    if(widget.selectedIngredients.isNotEmpty) {
      //selectedIngredients = List.from(widget.selectedIngredients);
      selectedIngredients = List.from(widget.ingredients);
      for (var element in selectedIngredients) {
        /*if(widget.selectedIngredients.contains(element)){
          log("==contains so setting true for ${element.name}");
          element.isChecked = true;
        }*/
        element.isChecked = widget.selectedIngredients.where((el) => element.id == el.id).isNotEmpty;
        //element.weight = widget.selectedIngredients.where((el) => element.id == el.id).f;
        if(widget.selectedIngredients.where((el) => element.id == el.id).isNotEmpty){
          element.weight = widget.selectedIngredients.where((el) => element.id == el.id).first.weight;
        }
      }
    } else {
      log("==not contains ===========================");
      selectedIngredients = List.from(widget.ingredients);
    }
    //selectedIngredients = List.from(widget.ingredients);
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
              shrinkWrap: true,
              itemCount: selectedIngredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                    children: [
                      Expanded(
                        child: CheckboxListTile(
                          activeColor: kColorScheme.primary,
                          title: Text(selectedIngredients[index].name),
                          value: selectedIngredients[index].isChecked,
                          onChanged: (value) {
                            _toggleIngredient(index, value!);
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Quantity (g)',
                              hintText: 'Enter quantity',
                            ),
                            initialValue: selectedIngredients[index].weight != null ? selectedIngredients[index].weight.toString() : '',
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                selectedIngredients[index].weight = double.parse(value);
                              });
                            },
                          ),
                        ),
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