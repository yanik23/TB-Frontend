

import 'package:flutter/material.dart';
import '../welcomeScreen.dart';
import 'createDeliveryScreen.dart';
import '../../utils/widgets/searchBar.dart' as sb;


/// This class is used to display the add dishes to delivery screen
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class AddDishesToDeliveryScreen extends StatefulWidget {
  final List<DishCheck> dishes;
  final List<DishCheck> selectedDishes;


  const AddDishesToDeliveryScreen(this.dishes, this.selectedDishes, {super.key});

  @override
  State<AddDishesToDeliveryScreen> createState() => _AddDishesToDeliveryScreenState();
}

/// This class is used to manage the state of the add dishes to delivery screen
class _AddDishesToDeliveryScreenState extends State<AddDishesToDeliveryScreen> {

  // the full list of dishes to be displayed
  List<DishCheck> dishes = [];
  // the list of dishes selected by the user
  List<DishCheck> selectedDishes = [];
  // the list of dishes searched by the user
  List<DishCheck> searchedDishes = [];
  // show search bar
  bool _showSearchBar = false;
  // editing controller for the search bar
  TextEditingController editingController = TextEditingController();

  /// This function is used to initialize the state of the add dishes to delivery screen
  @override
  void initState() {
    super.initState();
    setState(() {

    selectedDishes = List.from(widget.dishes);
    if (widget.selectedDishes.isNotEmpty) {
      for (var element in selectedDishes) {
        element.isChecked = widget.selectedDishes
            .where((el) => element.id == el.id)
            .isNotEmpty;
        if (widget.selectedDishes
            .where((el) => element.id == el.id)
            .isNotEmpty) {
          element.quantityRemained= widget.selectedDishes
              .where((el) => element.id == el.id)
              .first
              .quantityRemained;
          element.quantityDelivered = widget.selectedDishes
              .where((el) => element.id == el.id)
              .first
              .quantityDelivered;
        }
      }
    }
    searchedDishes = selectedDishes;
    });
  }

  /// This function is used to toggle the dish
  void _toggleDish(int index, bool value) {
    setState(() {
      selectedDishes[index].isChecked = value;
      searchedDishes[index].isChecked = value;
    });
  }

  /// This function is used to add the selected dishes to the delivery
  void _onAddPressed() {
    List<DishCheck> sd = searchedDishes.where((element) => element.isChecked).toList();
    Navigator.of(context).pop(sd);
  }


  /// This function is used to filter the dishes searched by the user
  void _filterSearchResults(String query) {
    setState(() {
      searchedDishes = selectedDishes
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }



  /// This function is used to build the add dishes to delivery screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Ingredients'), actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            setState(() {
              _showSearchBar = !_showSearchBar;
            });
          },
        ),
      ]),
      body: Column(
        children: <Widget>[
          if (_showSearchBar) sb.SearchBar(editingController, _filterSearchResults),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: searchedDishes.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 150,
                  child: Column(
                    children: [
                        CheckboxListTile(
                          activeColor: kColorScheme.primary,
                          title: Text(searchedDishes[index].name, style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: kColorScheme.primary
                          ),
                          ),
                          value: searchedDishes[index].isChecked,
                          onChanged: (value) {
                            _toggleDish(index, value!);
                          },
                      ),
                      Row(
                        children: [

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Quantity Remained',
                                  hintText: 'Enter quantity Remained',
                                ),
                                initialValue:
                                searchedDishes[index].quantityRemained != null
                                    ? searchedDishes[index].quantityRemained.toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    searchedDishes[index].quantityRemained = int.parse(value);
                                  });
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  labelText: 'Quantity Delivered',
                                  hintText: 'Enter quantity to Deliver',
                                ),
                                initialValue:
                                searchedDishes[index].quantityDelivered != null
                                    ? searchedDishes[index].quantityDelivered.toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    searchedDishes[index].quantityDelivered = int.parse(value);
                                  });
                                },
                              ),
                            ),
                          ),
                          //const SizedBox(height: 16.0),
                        ],
                      ),
                    ],
                  ),
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
                  Navigator.of(context).pop();
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