
import 'dart:async';
import 'dart:async';


import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/createDishScreen.dart';
import 'package:tb_frontend/screens/dishes/dishDetailsScreen.dart';
import '../../data/dummyDishes.dart';
import '../../models/dish.dart';
import 'dishItem.dart';


class DishesScreen extends StatefulWidget {
  final String? title;

  const DishesScreen(this.title, {super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  //final List<Dish> dishes = dummyDishes;
  late Future<List<Dish>> dishes;
  List<Dish> localDishes = [];
  List<Dish> searchedDishes = [];
  TextEditingController editingController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    dishes = fetchDishes();
    dishes.then((value) => {
      localDishes.addAll(value),
      searchedDishes.addAll(value),

      /*if(value.isEmpty) {
        localDishes.addAll(dummyDishes),
        searchedDishes.addAll(dummyDishes)
      }*/
    });
  }

  void _selectDish(BuildContext context, Dish dish) async{
    final upgradedDish = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DishDetailsScreen(dish),
      ),
    );
    if(upgradedDish != null) {
      setState(() {
        localDishes.remove(dish);
        localDishes.add(upgradedDish);
        searchedDishes.remove(dish);
        searchedDishes.add(upgradedDish);
      });
    }
  }

  void _createDish() async{
    final newDish = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateDishScreen(),
      ),
    );
    if(newDish != null) {
      setState(() {
        localDishes.add(newDish);
        searchedDishes.add(newDish);
      });
    }
  }

  Future _refreshDish() async {
    setState(() {
      dishes = fetchDishes();
      dishes.then((value) => {
        localDishes.clear(),
        localDishes.addAll(value),
        searchedDishes.clear(),
        searchedDishes.addAll(value)
      });
    });
  }

  void _deleteDish(Dish dish) async{
    deleteDish(dish.id);
    setState(() {
      localDishes.remove(dish);
      searchedDishes.remove(dish);
    });
  }

  void _filterSearchResults(String query) {
    setState(() {
      searchedDishes = localDishes
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


    Widget content = FutureBuilder<List<Dish>>(
      future: dishes,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshDish,
            child: Column(
              children: [
                if(_showSearchBar) searchBar,
                Expanded(
                  child: ListView.builder(
                    itemCount: searchedDishes.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          showDialog(context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Delete Dish'),
                              content: const Text('Are you sure you want to delete this Dish?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      DishItem(searchedDishes[index], _selectDish);
                                    });
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteDish(searchedDishes[index]);
                                    Navigator.of(ctx).pop();

                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );
                        },
                        child: DishItem(searchedDishes[index], _selectDish));
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
        title: Text(widget.title!),
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
              _createDish();
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
