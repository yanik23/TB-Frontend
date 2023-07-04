

import 'package:flutter/material.dart';

import '../../models/ingredient.dart';
import 'createIngredientScreen.dart';
import 'ingredientDetailsScreen.dart';
import 'ingredientItem.dart';


class IngredientsScreen extends StatelessWidget {

  late Future<List<Ingredient>> ingredients = fetchIngredients();

  IngredientsScreen({super.key});

  void _selectDish(BuildContext context, Ingredient dish) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => IngredientDetailsScreen(dish),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = FutureBuilder<List<Ingredient>>(
      future: ingredients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return IngredientItem(snapshot.data![index], _selectDish);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const CreateIngredientScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: content,
    );
  }
}