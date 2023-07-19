import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../models/ingredient.dart';
import 'createIngredientScreen.dart';
import 'ingredientDetailsScreen.dart';
import 'ingredientItem.dart';

class IngredientsScreen extends StatefulWidget {
  const IngredientsScreen({super.key});

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  late Future<List<Ingredient>> ingredients;
  List<Ingredient> localIngredients = [];
  List<Ingredient> searchedIngredients = [];

  bool _showSearchBar = false;

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ingredients = fetchIngredients();
    ingredients.then((value) => {
      setState(() {
        localIngredients.addAll(value);
        searchedIngredients.addAll(value);
      })
      });
            /*localIngredients.addAll(value),
            searchedIngredients.addAll(value),
        });*/
  }

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

  void _createIngredient() async {
    final newIngredient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateIngredientScreen(),
      ),
    );
    if (newIngredient != null) {
      setState(() {
        localIngredients.add(newIngredient);
        searchedIngredients.add(newIngredient);
      });
    }
  }

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
      // TODO : workaround for now, need to fix.
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

  void _filterSearchResults(String query) {
    setState(() {
      searchedIngredients = localIngredients
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future _refreshIngredients() async {
    setState(() {
      ingredients = fetchIngredients();
      ingredients.then((value) => {
            localIngredients.clear(),
            localIngredients.addAll(value),
            searchedIngredients.clear(),
            searchedIngredients.addAll(value)
          });
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
          labelText: "Search",
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );

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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
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
