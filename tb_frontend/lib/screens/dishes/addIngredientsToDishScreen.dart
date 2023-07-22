import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';

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

  @override
  void initState() {
    super.initState();
    if (widget.selectedIngredients.isNotEmpty) {
      log("==contains ===========================");
      for(var el in widget.selectedIngredients){
        log("==contains so setting true for ${el.name}");
      }

      //selectedIngredients = List.from(widget.selectedIngredients);
      selectedIngredients = List.from(widget.ingredients);
      for (var element in selectedIngredients) {
        /*if(widget.selectedIngredients.contains(element)){
          log("==contains so setting true for ${element.name}");
          element.isChecked = true;
        }*/
        element.isChecked = widget.selectedIngredients
            .where((el) => element.id == el.id)
            .isNotEmpty;
        //element.weight = widget.selectedIngredients.where((el) => element.id == el.id).f;
        if (widget.selectedIngredients.where((el) => element.id == el.id)
            .isNotEmpty) {
          element.weight = widget.selectedIngredients
              .where((el) => element.id == el.id)
              .first
              .weight;
        }
      }
    } else {
      log("==not contains ===========================");
      selectedIngredients = List.from(widget.ingredients);
    }
    //selectedIngredients = List.from(widget.ingredients);
    searchedIngredients.clear();
    searchedIngredients.addAll(selectedIngredients);
  }

  void _toggleIngredient(int index, bool value) {
    setState(() {
      searchedIngredients[index].isChecked = value;
    });
  }

  void _onAddPressed() {
    List<IngredientCheck> si = searchedIngredients
        .where((ingredient) => ingredient.isChecked)
        .toList();

    Navigator.pop(context, si);
  }

  void _filterSearchResults(String query) {
    setState(() {
      searchedIngredients = widget.ingredients
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
              itemCount: searchedIngredients.length,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Expanded(
                      child: CheckboxListTile(
                        activeColor: kColorScheme.primary,
                        title: Text(searchedIngredients[index].name),
                        value: searchedIngredients[index].isChecked,
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
                          initialValue:
                              searchedIngredients[index].weight != null
                                  ? searchedIngredients[index].weight.toString()
                                  : '',
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              searchedIngredients[index].weight =
                                  double.parse(value);
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
