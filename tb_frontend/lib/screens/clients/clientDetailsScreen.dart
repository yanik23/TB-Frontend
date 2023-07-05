
import 'package:flutter/material.dart';

import '../../models/client.dart';


class ClientDetailsScreen extends StatelessWidget {
  //static const routeName = '/dish-details-screen';

  final Client tempClient;

  late Future<Client> client = fetchClient(tempClient.id);

  ClientDetailsScreen(this.tempClient, {super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dish Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return GenerateQRCodeScreen(dish);
                  },
                ),
              );*/
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Client>(
            future: client,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /*TextFormField(
                    initialValue: snapshot.data!.name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    readOnly: _isEditable,
                  ),*/
                    Text(
                      snapshot.data!.name,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Address:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text("${snapshot.data!.addressName} ${snapshot.data!.addressNumber}"),
                    const SizedBox(height: 16.0),
                    Text(
                      'Zip Code:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text('${snapshot.data!.city} ${snapshot.data!.zipCode}'),
                    const SizedBox(height: 32.0),

                    ElevatedButton(onPressed: () {

                      // _isEditable = !_isEditable;
                    }, child: Text('Edit')),

                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
      ),
    );
  }
}
