




import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../models/client.dart';

class ClientItem extends StatelessWidget {
  final Client client;
  final Function(BuildContext context, Client client) onSelect;

  const ClientItem(this.client, this.onSelect, {super.key});


  /*String get complexityText {
    return dish.complexity.name[0].toUpperCase() + dish.complexity.name.substring(1);
  }

  String get affordabilityText {
    return dish.affordability.name[0].toUpperCase() + dish.affordability.name.substring(1);
  }*/

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: 4,
      child: InkWell(
        onTap: () {
          onSelect(context, client);
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
                const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                child: Column(children: [
                  Text(
                    client.name,
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
                        Text(
                          "${client.addressName}  ",
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
                        Text(
                          client.addressNumber.toString(),
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
                        Text(
                          "${client.zipCode}  ",
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
                        Text(
                          client.city,
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