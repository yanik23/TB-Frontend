import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';

import '../../utils/constants.dart';
import 'createDishScreen.dart';

class AddIngredientsToDishScreen extends StatefulWidget {
  final List<IngredientCheck> ingredients;
  final List<IngredientCheck> selectedIngredients;

  const AddIngredientsToDishScreen(this.ingredients, this.selectedIngredients,
      {super.key});

  @override
  State<AddIngredientsToDishScreen> createState() =>
      _AddIngredientsToDishScreenState();
}

class _AddIngredientsToDishScreenState extends State<AddIngredientsToDishScreen> {
  List<IngredientCheck> selectedIngredients = [];
  List<IngredientCheck> searchedIngredients = [];
  bool _showSearchBar = false;
  TextEditingController editingController = TextEditingController();
  Map<int, TextEditingController> textEditingControllerMap = {};

  final RegExp _doubleRegExp = RegExp(doubleRegexPattern);

  @override
  void initState() {
    super.initState();

    selectedIngredients = List.from(widget.ingredients);
    if (widget.selectedIngredients.isNotEmpty) {
      for (var element in selectedIngredients) {
        element.isChecked = widget.selectedIngredients
            .where((el) => element.id == el.id)
            .isNotEmpty;
        if (widget.selectedIngredients
            .where((el) => element.id == el.id)
            .isNotEmpty) {
          element.weight = widget.selectedIngredients
              .where((el) => element.id == el.id)
              .first
              .weight;
        }
      }
    }
  }

  @override
  void dispose() {
    for (final controller in textEditingControllerMap.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleIngredient(int index, bool value) {
    setState(() {
      selectedIngredients[index].isChecked = value;
      //widget.ingredients[index].isChecked = value;
    });
  }

  void _onAddPressed() {
    List<IngredientCheck> si = selectedIngredients
        .where((ingredient) => ingredient.isChecked)
        .toList();

    Navigator.pop(context, si);
  }

  void _filterSearchResults(String query) {
    setState(() {
      selectedIngredients = widget.ingredients
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      for (var element in searchedIngredients) {
        /*element.weight = widget.ingredients
            .where((el) => element.id == el.id)
            .first
            .weight;*/
        log("==setting weight for ${element.name} to ${element.weight}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          _filterSearchResults(value);
        },
        controller: editingController,
        decoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Search',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Select Ingredients'), actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _showSearchBar = !_showSearchBar;
              if (!_showSearchBar) {
                // Reset the search results when closing the search bar
                searchedIngredients = List.from(widget.ingredients);
              }
            });
          },
        ),
      ]),
      body: Column(
        children: <Widget>[
          if (_showSearchBar) searchBar,
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
                          //controller: textEditingController,
                          decoration: const InputDecoration(
                            labelText: 'Quantity (g)',
                            hintText: 'Enter quantity',
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          initialValue:
                              selectedIngredients[index].weight != null
                                  ? selectedIngredients[index].weight.toString()
                                  : '',
                          validator: (value) {
                            if (!_doubleRegExp.hasMatch(value!)) {
                              return 'Please enter a valid quantity';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              selectedIngredients[index].weight =
                                  double.tryParse(value);
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
