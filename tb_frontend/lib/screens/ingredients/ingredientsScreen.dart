

import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import 'createIngredientScreen.dart';
import 'ingredientDetailsScreen.dart';
import 'ingredientItem.dart';


/// This class is used to display the ingredients screen of the application.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  // ingredients fetched from the backend
  late Future<List<Ingredient>> ingredients;
  // local ingredients list
  List<Ingredient> localIngredients = [];
  // searched ingredients list
  List<Ingredient> searchedIngredients = [];

  // show error message
  bool _showSearchBar = false;

  // editing controller for the search bar
  TextEditingController editingController = TextEditingController();

  /// This function is used to initialize the state of the ingredients screen.
  /// It fetches the ingredients from the backend. If an error occurs, it shows a snackbar.
  @override
  void initState() {
    super.initState();
    ingredients = fetchIngredients().catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        return List<Ingredient>.empty();
      }
    });
    ingredients.then((value) => {
        localIngredients.addAll(value),
        searchedIngredients.addAll(value),
      });
  }

  /// This function is used to select an ingredient.
  /// It navigates to the ingredient details screen.
  /// If the ingredient is updated, it updates the local ingredients list.
  void _selectIngredient(BuildContext context, Ingredient dish) async {
    final updatedIngredient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => IngredientDetailsScreen(dish),
      ),
    );
    if (updatedIngredient != null) {
      setState(() {
        localIngredients.remove(dish);
        localIngredients.add(updatedIngredient);
        searchedIngredients.remove(dish);
        searchedIngredients.add(updatedIngredient);
      });
    }
  }

  /// This function is used to create an ingredient.
  /// It navigates to the create ingredient screen.
  /// If the ingredient is created, it updates the local ingredients list.
  void _createIngredient() async {
    final newIngredient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateIngredientScreen('Create Ingredient'),
      ),
    );
    if (newIngredient != null) {
      setState(() {
        localIngredients.add(newIngredient);
        searchedIngredients.add(newIngredient);
      });
    }
  }

  /// This function is used to delete an ingredient.
  /// It shows a dialog to confirm the deletion or if the deletion was not successful.
  /// If the ingredient is deleted, it updates the local ingredients list.
  void _deleteIngredient(Ingredient ingredient) async {
    final statusCode = await deleteIngredient(ingredient.id).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        setState(() {});
        return HttpStatus.forbidden;
      }
    });
    if (statusCode == HttpStatus.noContent) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Ingredient deleted successfully.",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
      setState(() {
        localIngredients.remove(ingredient);
        searchedIngredients.remove(ingredient);
      });
    }
  }

  /// This function is used to filter the ingredients list when using the searchbar.
  /// It updates the searched ingredients list.
  void _filterSearchResults(String query) {
    setState(() {
      searchedIngredients = localIngredients
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// This function is used to refresh the ingredients list.
  /// It updates the local ingredients list by fetching the ingredients from the backend.
  Future _refreshIngredients() async {
    setState(() {
      ingredients = fetchIngredients().catchError((error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Colors.red,
              showCloseIcon: true,
              closeIconColor: Colors.white,
            ),
          );
        }
      });
      ingredients.then((value) => {
            localIngredients.clear(),
            localIngredients.addAll(value),
            searchedIngredients.clear(),
            searchedIngredients.addAll(value)
          });
    });
  }

  /// This function is used to build the ingredients screen.
  @override
  Widget build(BuildContext context) {
    /// This widget is used to display a search bar.
    Widget searchBar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          _filterSearchResults(value);
        },
        controller: editingController,
        decoration: const InputDecoration(
          labelText: "Search",
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );

    /// This widget is used to display the ingredients.
    Widget content = FutureBuilder<List<Ingredient>>(
      future: ingredients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshIngredients, //_refreshIngredients
            child: Column(
              children: <Widget>[
                if (_showSearchBar) searchBar,
                Expanded(
                  child: ListView.builder(
                    itemCount: searchedIngredients.length,
                    itemBuilder: (context, index) => Dismissible(
                          key: UniqueKey(),
                          onDismissed: (direction) {
                            /// This widget is used to display a dialog to confirm the deletion of an ingredient.
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Ingredient"),
                                content: const Text(
                                    "Are you sure you want to delete this ingredient?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        IngredientItem(
                                            searchedIngredients[index],
                                            _selectIngredient);
                                      });
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteIngredient(
                                          searchedIngredients[index]);
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: IngredientItem(searchedIngredients[index], _selectIngredient),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ingredients"),
        actions: [
          /// This button is used to toggle the search bar.
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
          /// This button is used to navigate to the create ingredient screen.
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _createIngredient();
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
