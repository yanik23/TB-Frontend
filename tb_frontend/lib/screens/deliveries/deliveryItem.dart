
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/delivery.dart';


// date format used for the delivery date
final formatter = DateFormat('dd/MM/yyyy');

/// This class is used to create a delivery item widget
///
/// Inspired and adapted from : https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DeliveryItem extends StatelessWidget {
  final Delivery delivery;
  final Function(BuildContext context, Delivery delivery) onSelect;

  const DeliveryItem(this.delivery, this.onSelect, {super.key});

  /// This function is used to build the delivery item
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: InkWell(
        onTap: () {
          onSelect(context, delivery);
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
              height: 100,
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
                      'Delivery id : ${delivery.id}',
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
                        const Icon(Icons.person, color: Colors.white,),
                        Container(
                          child: Text(
                            delivery.username,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            softWrap: true, //so the text is wrapped well if needed
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Spacer(),


                        const Icon(Icons.calendar_month, color: Colors.white,),
                        Text(
                          formatter.format(delivery.deliveryDate),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true, //so the text is wrapped well if needed
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ]
                  ),
                  const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.delivery_dining, color: Colors.white,),
                          Expanded(
                            child: Text(
                              delivery.clientName,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              softWrap: true, //so the text is wrapped well if needed
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ),
            )
          ],
        ),
      ),
    );
  }
}