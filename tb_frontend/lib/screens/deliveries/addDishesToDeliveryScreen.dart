

import 'package:flutter/material.dart';


class AddDishesToDeliveryScreen extends StatefulWidget {
  final List<DishCheck> dishes;
  final List<DishCheck> selectedDishes;


  const AddDishesToDeliveryScreen(this.dishes, this.selectedDishes, {super.key});

  @override
  State<AddDishesToDeliveryScreen> createState() => _AddDishesToDeliveryScreenState();
}

class _AddDishesToDeliveryScreenState extends State<AddDishesToDeliveryScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}