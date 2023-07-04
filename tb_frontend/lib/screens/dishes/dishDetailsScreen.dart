

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/generateQRCodeScreen.dart';


import '../../models/dish.dart';

class DishDetailsScreen extends StatelessWidget {
  //static const routeName = '/dish-details-screen';

  final Dish tempDish;

  late Future<Dish> dish = fetchDish(tempDish.id);

  DishDetailsScreen(this.tempDish, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dish Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return GenerateQRCodeScreen(tempDish);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<Dish>(
          future: dish,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.name ?? 'N/A',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.description ?? 'N/A'),
                  SizedBox(height: 16.0),
                  Text(
                    'Type:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.currentType),
                  SizedBox(height: 16.0),
                  Text(
                    'Size:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.currentSize),
                  SizedBox(height: 16.0),
                  Text(
                    'Price:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text('\$${snapshot.data!.price.toStringAsFixed(2)}'),
                  SizedBox(height: 16.0),
                  Text(
                    'Availability:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.isAvailable ? 'Available' : 'Not Available'),
                  SizedBox(height: 16.0),
                  Text(
                    'Nutritional Information:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  buildNutritionRow('Calories', snapshot.data!.calories.toString()),
                  buildNutritionRow('Fats', snapshot.data!.fats?.toStringAsFixed(2) ?? 'N/A'),
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
                ],
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return const CircularProgressIndicator();
          },
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