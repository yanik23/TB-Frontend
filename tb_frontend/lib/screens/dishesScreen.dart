import 'package:flutter/material.dart';
import 'package:tb_frontend/data/dummyDishes.dart';
import 'package:tb_frontend/screens/add_dish_screen.dart';
import 'package:tb_frontend/screens/dishDetailsScreen.dart';

import '../models/dish.dart';
import 'dishItem.dart';

class DishesScreen extends StatelessWidget {
  final String? title;
  //final List<Dish> dishes = dummyDishes;
  late Future<List<Dish>> dishes = fetchDishes();

  DishesScreen(this.title, {super.key});

  void _selectDish(BuildContext context, Dish dish) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const DishDetailsScreen(),
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

    /*Widget content = ListView.builder(
      itemCount: dishes.length,
      itemBuilder: (ctx, index) => DishItem(dishes[index], _selectDish),
    );*/

    /*if (dishes.isEmpty) {
      content = Center(
          child: Column(
            children: [
              Text('No dishs found',
                  style: Theme.of(context)
                      .textTheme
                      .headlineLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground)),
              const SizedBox(height: 16),
              const Icon(Icons.warning_amber_rounded),
              Text(
                'Try selecting another category',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground),
              ),
            ],
          ));
    }

    if(title == null) {
      return content;
    }*/

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
