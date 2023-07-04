import 'package:flutter/material.dart';

class DishItemTrait extends StatelessWidget {
  final IconData icon;
  final String label;

  const DishItemTrait(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.white),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}