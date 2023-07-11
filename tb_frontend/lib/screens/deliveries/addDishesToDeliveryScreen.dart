

import 'package:flutter/material.dart';

import '../welcomeScreen.dart';
import 'createDeliveryScreen.dart';


class AddDishesToDeliveryScreen extends StatefulWidget {
  final List<DishCheck> dishes;
  final List<DishCheck> selectedDishes;


  const AddDishesToDeliveryScreen(this.dishes, this.selectedDishes, {super.key});

  @override
  State<AddDishesToDeliveryScreen> createState() => _AddDishesToDeliveryScreenState();
}

class _AddDishesToDeliveryScreenState extends State<AddDishesToDeliveryScreen> {
  List<DishCheck> selectedDishes = [];
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDishes.isNotEmpty) {
      selectedDishes = List.from(widget.dishes);
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
    } else {
      selectedDishes = List.from(widget.dishes);
    }
    //selectedIngredients = List.from(widget.ingredients);
  }

  void _toggleDish(int index, bool value) {
    setState(() {
      selectedDishes[index].isChecked = value;
    });
  }

  void _onAddPressed() {
    List<DishCheck> sd = selectedDishes.where((element) => element.isChecked).toList();
    Navigator.of(context).pop(sd);
  }


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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: selectedDishes.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  height: 150,
                  child: Column(
                    children: [
                        CheckboxListTile(
                          activeColor: kColorScheme.primary,
                          title: Text(selectedDishes[index].name, style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: kColorScheme.primary
                          ),
                          ),
                          value: selectedDishes[index].isChecked,
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
                                selectedDishes[index].quantityRemained != null
                                    ? selectedDishes[index].quantityRemained.toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDishes[index].quantityRemained = int.parse(value);
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
                                selectedDishes[index].quantityDelivered != null
                                    ? selectedDishes[index].quantityDelivered.toString()
                                    : '',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    selectedDishes[index].quantityDelivered = int.parse(value);
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
                  Navigator.pop(context);
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