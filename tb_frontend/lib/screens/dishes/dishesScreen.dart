
import 'dart:async';
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/createDishScreen.dart';
import 'package:tb_frontend/screens/dishes/dishDetailsScreen.dart';
import '../../models/dish.dart';
import 'dishItem.dart';


class DishesScreen extends StatelessWidget {
  final String? title;
  //final List<Dish> dishes = dummyDishes;
  late Future<List<Dish>> dishes = fetchDishes();

  DishesScreen(this.title, {super.key});

  void _selectDish(BuildContext context, Dish dish) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DishDetailsScreen(dish),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = FutureBuilder<List<Dish>>(
      future: dishes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return DishItem(snapshot.data![index], _selectDish);
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
        title: Text(title!),
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
                    return const CreateDishScreen();
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
