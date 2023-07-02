

import 'package:flutter/material.dart';

class DishDetailsScreen extends StatefulWidget {
  static const routeName = '/dish-details-screen';

  const DishDetailsScreen({super.key});

  @override
  State<DishDetailsScreen> createState() => _DishDetailsScreenState();
}


class _DishDetailsScreenState extends State<DishDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dish Details'),
      ),
      body: Container(),);
  }
}