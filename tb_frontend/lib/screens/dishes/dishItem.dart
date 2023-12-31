
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/dish.dart';
import 'dishItemTrait.dart';


/// This class is used to generate a dish item  widget of the application.
///
/// Inspired and adapted from : https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DishItem extends StatelessWidget {

  // dish to display
  final Dish dish;

  final Function(BuildContext context, Dish dish) onSelect;

  const DishItem(this.dish, this.onSelect, {super.key});

  /// This function is used to build the dish item.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: InkWell(
        onTap: () {
          onSelect(context, dish);
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
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Column(children: [
                  Text(
                    dish.name,
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
                      //alignment: WrapAlignment.center,
                      //spacing: 8,
                      children: [
                        DishItemTrait(Icons.monetization_on, '${dish.price} CHF'),
                        const Spacer(),
                        DishItemTrait(Icons.local_fire_department, '${dish.calories}'),
                        const Spacer(),
                        DishItemTrait(Icons.format_size, dish.currentSize),
                        const Spacer(),
                        DishItemTrait(Icons.category, dish.currentType)
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