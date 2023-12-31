
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../../models/client.dart';


/// This class is used to display a client item.
/// It is used in the client list screen.
/// Inspired and adapted from : https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class ClientItem extends StatelessWidget {
  final Client client;
  final Function(BuildContext context, Client client) onSelect;

  const ClientItem(this.client, this.onSelect, {super.key});

  /// This function is used to build the client item.
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
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                  Wrap(
                     // spacing: double.infinity,
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       // Container(width: double.infinity),
                        Text(
                          '${client.addressName} ${client.addressNumber}',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          softWrap: true, //so the text is wrapped well if needed
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '${client.zipCode} ${client.city}',
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