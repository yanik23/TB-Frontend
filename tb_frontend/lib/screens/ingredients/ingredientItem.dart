

import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/ingredient.dart';


/// This class is used generate an ingredient item Widget.
/// It is used in the ingredients screen.
/// Inspired by: https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class IngredientItem extends StatelessWidget {

  // ingredient to display
  final Ingredient ingredient;
  final Function(BuildContext context, Ingredient ingredient) onSelect;

  const IngredientItem(this.ingredient, this.onSelect, {super.key});

  /// This function is used to build the ingredient item.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: InkWell(
        onTap: () {
          onSelect(context, ingredient);
        },
        splashColor:
        Theme.of(context).colorScheme.onBackground.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: const AssetImage('assets/images/bokafood-logo.png'),
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Column(children: [
                  Text(
                    ingredient.name,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    softWrap: true, //so the text is wrapped well if needed
                    overflow: TextOverflow.fade,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.category, size: 17, color: Colors.white),
                        const SizedBox(width: 8),
                        Text(ingredient.type.toString(), style: const TextStyle(color: Colors.white)),
                      ]
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}