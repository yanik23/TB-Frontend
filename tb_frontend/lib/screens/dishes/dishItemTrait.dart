import 'package:flutter/material.dart';


/// This class is used to display the ingredient details screen of the application.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DishItemTrait extends StatelessWidget {
  final IconData icon;
  final String label;

  const DishItemTrait(this.icon, this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Icon(icon, size: 17, color: Colors.white),
        //const SizedBox(width: 8),
        Text(label,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.fade,
            style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}