

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/dishes/generateQRCodeScreen.dart';

import '../../models/dish.dart';

class DishDetailsScreen extends StatelessWidget {
  //static const routeName = '/dish-details-screen';

  final Dish dish;
  const DishDetailsScreen(this.dish, {super.key});

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
                    return GenerateQRCodeScreen(dish);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dish.name,
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
            Text(dish.description ?? 'N/A'),
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
            Text(dish.currentType),
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
            Text(dish.currentSize),
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
            Text('\$${dish.price.toStringAsFixed(2)}'),
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
            Text(dish.isAvailable ? 'Available' : 'Not Available'),
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
            buildNutritionRow('Calories', dish.calories.toString()),
            buildNutritionRow('Fats', dish.fats?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow(
                'Saturated Fats', dish.saturatedFats?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Sodium', dish.sodium?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow(
                'Carbohydrates', dish.carbohydrates?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Fibers', dish.fibers?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Sugars', dish.sugars?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Proteins', dish.proteins?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Calcium', dish.calcium?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Iron', dish.iron?.toStringAsFixed(2) ?? 'N/A'),
            buildNutritionRow('Potassium', dish.potassium?.toStringAsFixed(2) ?? 'N/A'),
          ],
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