

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';
import '../../utils/constants.dart';
import 'createDishScreen.dart';


/// This class is used to display the ingredients to be added for a dish.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class AddIngredientsToDishScreen extends StatefulWidget {
  final List<IngredientCheck> ingredients;
  final List<IngredientCheck> selectedIngredients;

  const AddIngredientsToDishScreen(this.ingredients, this.selectedIngredients,
      {super.key});

  @override
  State<AddIngredientsToDishScreen> createState() =>
      _AddIngredientsToDishScreenState();
}

/// This class is used to manage the state of the ingredients to be added for a dish.
class _AddIngredientsToDishScreenState extends State<AddIngredientsToDishScreen> {

  // the list of ingredients selected by the user
  List<IngredientCheck> selectedIngredients = [];
  // the list of ingredients searched by the user
  List<IngredientCheck> searchedIngredients = [];
  // show search bar
  bool _showSearchBar = false;
  // editing controller for the search bar
  TextEditingController editingController = TextEditingController();
  //Map<int, TextEditingController> textEditingControllerMap = {};

  // regex pattern for validation
  final RegExp _doubleRegExp = RegExp(doubleRegexPattern);

  /// This function is used to initialize the state of the ingredients to be added for a dish.
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


  /// This function is used to toggle an ingredient.
  void _toggleIngredient(int index, bool value) {
    setState(() {
      selectedIngredients[index].isChecked = value;
      //widget.ingredients[index].isChecked = value;
    });
  }

  /// This function is used to add the selected ingredients to the dish.
  void _onAddPressed() {
    List<IngredientCheck> si = selectedIngredients
        .where((ingredient) => ingredient.isChecked)
        .toList();

    Navigator.pop(context, si);
  }

  /// This function is used to filter the search results.
  void _filterSearchResults(String query) {
    setState(() {
      selectedIngredients = widget.ingredients
          .where((ingredient) =>
              ingredient.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// This function is used to build the screen.
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
