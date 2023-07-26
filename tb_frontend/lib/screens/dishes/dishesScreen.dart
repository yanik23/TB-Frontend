
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/createDishScreen.dart';
import 'package:tb_frontend/screens/dishes/dishDetailsScreen.dart';
import '../../models/dish.dart';
import 'dishItem.dart';


/// This class is used to display the dishes screen of the application.
/// It is used to display all dishes.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DishesScreen extends StatefulWidget {

  // title of the screen
  final String? title;

  const DishesScreen(this.title, {super.key});

  @override
  State<DishesScreen> createState() => _DishesScreenState();
}

class _DishesScreenState extends State<DishesScreen> {
  // dishes fetched from the backend
  late Future<List<Dish>> dishes;
  // local dishes list
  List<Dish> localDishes = [];
  // searched dishes list
  List<Dish> searchedDishes = [];
  // editing controller for the search bar
  TextEditingController editingController = TextEditingController();
  // show search bar
  bool _showSearchBar = false;

  /// This function is used to initialize the state of the dishes screen.
  @override
  void initState() {
    super.initState();
    dishes = fetchDishes();
    dishes.then((value) => {
      localDishes.addAll(value),
      searchedDishes.addAll(value),
    });
  }

  /// This function is used to select a dish.
  /// It navigates to the dish details screen.
  /// If the dish was edited, it updates the dishes screen.
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

  /// This function is used to create a dish.
  /// It navigates to the create dish screen.
  /// If the dish was created, it updates the dishes screen.
  void _createDish() async{
    final newDish = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateDishScreen('Create Dish'),
      ),
    );
    if(newDish != null) {
      setState(() {
        localDishes.add(newDish);
        searchedDishes.add(newDish);
      });
    }
  }

  /// This function is used to refresh the dishes screen.
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

  /// This function is used to delete a dish.
  /// If the dish was deleted successfully, it updates the dishes screen and shows a snackbar.
  /// If an error occurs, it shows a snackbar.
  void _deleteDish(Dish dish) async{
    final response = await deleteDish(dish.id).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You don\'t have the permission to delete this dish',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
      setState(() {});
    });
    setState(() {
      localDishes.remove(dish);
      searchedDishes.remove(dish);
    });
    if (response.statusCode == HttpStatus.noContent) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Dish deleted successfully",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
      setState(() {
        localDishes.remove(dish);
        searchedDishes.remove(dish);
      });
    }
  }

  /// This function is used to filter the dishes list.
  void _filterSearchResults(String query) {
    setState(() {
      searchedDishes = localDishes
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// This function is used to build the dishes screen.
  @override
  Widget build(BuildContext context) {
    /// This widget is used to display the search bar.
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

    /// This widget is used to display the dishes.
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
