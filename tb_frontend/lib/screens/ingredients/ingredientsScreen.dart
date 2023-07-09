

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
      localIngredients.addAll(value),
      searchedIngredients.addAll(value)
      /*localIngredients.forEach((element) {
        element.status = "ok";
        element.remoteId = 23;
        insertIngredient(element);
      })*/
    });
  }

  void _selectIngredient(BuildContext context, Ingredient dish) async {
    final updatedIngredient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => IngredientDetailsScreen(dish),
      ),
    );
    if(updatedIngredient != null) {
      setState(() {
        localIngredients.remove(dish);
        localIngredients.add(updatedIngredient);
        searchedIngredients.remove(dish);
        searchedIngredients.add(updatedIngredient);
      });
    }
  }

  void _createIngredient() async{
    final newIngredient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateIngredientScreen(),
      ),
    );
    if(newIngredient != null) {
      setState(() {
        //ingredients = fetchIngredients();
        localIngredients.add(newIngredient);
        searchedIngredients.add(newIngredient);
        //newIngredient.status = "new";
        //insertIngredient(newIngredient);
      });
    }
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

  void _deleteIngredient(Ingredient ingredient) async {
    deleteIngredient(ingredient.id);
    setState(() {
      /*localIngredients.remove(ingredient);
      deleteIngredient(ingredient);*/
      ingredients = fetchIngredients();
    });
  }

  void _filterSearchResults(String query) {
    List<Ingredient> dummySearchList = [];
    dummySearchList.addAll(localIngredients);
    if(query.isNotEmpty) {
      List<Ingredient> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        localIngredients.clear();
        localIngredients.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        localIngredients.clear();
        localIngredients.addAll(dummySearchList);
      });
    }
  }

  void filterSearchResults(String query) {
    setState(() {
      searchedIngredients = localIngredients
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    Widget searchBar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          filterSearchResults(value);
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
            onRefresh: _refreshIngredients,//_refreshIngredients
            child: Column(
              children: <Widget>[
                if (_showSearchBar) searchBar,

                Expanded(
                  child: ListView.builder(
                    itemCount: searchedIngredients.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                          onDismissed: (direction) {
                          showDialog(context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text("Delete Ingredient"),
                                content: const Text("Are you sure you want to delete this ingredient?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        IngredientItem(searchedIngredients[index], _selectIngredient);
                                      });
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteIngredient(searchedIngredients[index]);
                                      Navigator.of(ctx).pop();

                                    },
                                    child: const Text("Yes"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: IngredientItem(searchedIngredients[index], _selectIngredient));
                    },
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