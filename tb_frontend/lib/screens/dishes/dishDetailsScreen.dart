

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/generateQRCodeScreen.dart';


import '../../models/dish.dart';
import 'createDishScreen.dart';

class DishDetailsScreen extends StatefulWidget {
  //static const routeName = '/dish-details-screen';

  final Dish tempDish;


  const DishDetailsScreen(this.tempDish, {super.key});

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

class _DishDetailsScreenState extends State<DishDetailsScreen> {
  late Future<Dish> dish;


  @override
  void initState() {
    super.initState();
    dish = fetchDish(widget.tempDish.id);
  }

  void _editDish(Dish d) async {
    final updatedDish = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CreateDishScreen(dish: d),
      ),
    );
    if(updatedDish != null) {
      setState(() {
        dish = fetchDish(updatedDish.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dish Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return GenerateQRCodeScreen(widget.tempDish);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(dish);
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Dish>(
            future: dish,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final localDish = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localDish.name ?? 'N/A',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDish.description ?? 'N/A'),
                    const SizedBox(height: 16.0),
                    Text(
                      'Type:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDish.currentType),
                    const SizedBox(height: 16.0),
                    Text(
                      'Size:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDish.currentSize),
                    const SizedBox(height: 16.0),
                    Text(
                      'Price:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text('\$${localDish.price.toStringAsFixed(2)}'),
                    const SizedBox(height: 16.0),
                    Text(
                      'Availability:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDish.isAvailable ? 'Available' : 'Not Available'),
                    const SizedBox(height: 16.0),
                    Text(
                      'Nutritional Information:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    buildNutritionRow('Calories', localDish.calories.toString()),
                    buildNutritionRow('Fats', localDish.fats?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow(
                        'Saturated Fats', snapshot.data!.saturatedFats?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Sodium', snapshot.data!.sodium?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow(
                        'Carbohydrates', snapshot.data!.carbohydrates?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Fibers', snapshot.data!.fibers?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Sugars', snapshot.data!.sugars?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Proteins', snapshot.data!.proteins?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Calcium', snapshot.data!.calcium?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Iron', snapshot.data!.iron?.toStringAsFixed(2) ?? 'N/A'),
                    buildNutritionRow('Potassium', snapshot.data!.potassium?.toStringAsFixed(2) ?? 'N/A'),
                    const SizedBox(height: 32.0),
                    Text(
                      'Ingredients:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 300.0),
                      child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: localDish.ingredients?.length ?? 0,
                          itemBuilder: (context, index) =>
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(localDish.ingredients?[index].name ?? 'N/A', style: TextStyle(
                                      fontSize: 18.0,
                                      //fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),),
                                  ),
                                  const Spacer(),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        const Icon(Icons.balance, color: Colors.orangeAccent),
                                        const SizedBox(width: 8.0),
                                        Text(localDish.ingredients?[index].weight != null ? '${localDish.ingredients?[index].weight}g' : 'N/A'),
                                        const Spacer(),
                                        /*const Text("Remained: "),
                                        Text(localDelivery.dishes?[index].quantityRemained.toString() ?? 'N/A'),
                                        const Spacer(),
                                        const Text("Delivered: "),
                                        Text(localDelivery.dishes?[index].quantityDelivered.toString() ?? 'N/A'),*/
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          // _isEditable = !_isEditable;
                          /*Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) =>
                                  CreateClientScreen(client: snapshot.data),
                            ),
                          );*/
                          _editDish(localDish);
                        },
                        child: const Text('Edit')),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            },
          ),



        ),
      ),
    );
  }

  Widget buildNutritionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}