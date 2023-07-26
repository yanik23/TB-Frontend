

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/generateQRCodeScreen.dart';
import '../../models/dish.dart';
import 'createDishScreen.dart';


/// This class is used to display the dish details screen of the application.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DishDetailsScreen extends StatefulWidget {

  // dish to display
  final Dish tempDish;

  const DishDetailsScreen(this.tempDish, {super.key});

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}

/// This class is used to manage the state of the dish details screen.
class _DishDetailsScreenState extends State<DishDetailsScreen> {

  // dish fetched from the backend
  late Future<Dish> dish;

  /// This function is used to initialize the state of the dish details screen.
  @override
  void initState() {
    super.initState();
    dish = fetchDish(widget.tempDish.id);
  }

  /// This function is used to edit a dish.
  void _editDish(Dish d) async {
    final updatedDish = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CreateDishScreen('Edit Dish',dish: d),
      ),
    );
    if(updatedDish != null) {
      setState(() {
        dish = fetchDish(updatedDish.id);
      });
    }
  }

  /// This function is used to build the dish details screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dish Details'),
        actions: [
          /// This button is used to navigate to the generate QR code screen.
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
                      localDish.name,
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
                    Text('${localDish.price.toStringAsFixed(2)} CHF'),
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
                    buildNutritionRow('Calories', '${localDish.calories} kcal'),
                    buildNutritionRow('Fats', localDish.fats != null ? '${localDish.fats?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Saturated Fats', localDish.saturatedFats != null ? '${localDish.saturatedFats?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Sodium', localDish.sodium != null ? '${localDish.sodium?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Carbohydrates', localDish.carbohydrates != null ? '${localDish.carbohydrates?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Fibers', localDish.fibers != null ? '${localDish.fibers?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Sugars', localDish.sugars != null ? '${localDish.sugars?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Proteins', localDish.proteins != null ? '${localDish.proteins?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Calcium', localDish.calcium != null ? '${localDish.calcium?.toStringAsFixed(2) } g' : 'N/A'),
                    buildNutritionRow('Iron', localDish.iron != null ? '${localDish.iron?.toStringAsFixed(2)} g' : 'N/A'),
                    buildNutritionRow('Potassium', localDish.potassium != null ? '${localDish.potassium?.toStringAsFixed(2)} g' : 'N/A'),
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

                    if(localDish.ingredients?.isEmpty ?? true)
                      const Text('N/A', /*style: TextStyle(
                        fontSize: 18.0,
                        //fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),*/),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 250.0),
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
                                        //const Spacer(),
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                            ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            _editDish(localDish);
                          },
                          child: const Text('Edit Dish')),
                    ),
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

  /// This function is used to build a nutrition row.
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