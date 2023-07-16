
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/delivery.dart';


final formatter = DateFormat('dd/MM/yyyy');

class DeliveryItem extends StatelessWidget {
  final Delivery delivery;
  final Function(BuildContext context, Delivery delivery) onSelect;

  const DeliveryItem(this.delivery, this.onSelect, {super.key});

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
                    'delivery id : ${delivery.id}',
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
                        Text(
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


                        /*DishItemTrait(Icons.monetization_on, '${dish.price} CHF'),
                        const Spacer(),
                        DishItemTrait(Icons.local_fire_department, '${dish.calories}'),
                        const Spacer(),
                        DishItemTrait(Icons.format_size, dish.currentSize),
                        const Spacer(),
                        DishItemTrait(Icons.category, dish.currentType)*/
                      ]
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.delivery_dining, color: Colors.white,),
                      Text(
                        delivery.clientName,
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
                    ],
                  ),
                  //const Spacer(),
                ]),

              ),
            )
          ],
        ),
      ),
    );
  }
}