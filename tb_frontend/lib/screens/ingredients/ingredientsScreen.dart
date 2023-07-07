

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
  
  @override
  void initState() {
    super.initState();
    ingredients = fetchIngredients();
    ingredients.then((value) => {
      localIngredients.addAll(value),
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


  @override
  Widget build(BuildContext context) {
    Widget content = FutureBuilder<List<Ingredient>>(
      future: ingredients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshIngredients,//_refreshIngredients
            child: ListView.builder(
              itemCount: snapshot.data!.length,
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
                                  IngredientItem(snapshot.data![index], _selectIngredient);
                                });
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteIngredient(snapshot.data![index]);
                                Navigator.of(ctx).pop();

                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: IngredientItem(snapshot.data![index], _selectIngredient));
              },
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
            onPressed: () {},
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