

import 'package:flutter/material.dart';

import '../../models/ingredient.dart';

class IngredientDetailsScreen extends StatelessWidget {
  //static const routeName = '/dish-details-screen';

  final Ingredient tempIngredient;

  late Future<Ingredient> ingredient = fetchIngredient(tempIngredient.id);

  IngredientDetailsScreen(this.tempIngredient, {super.key});


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
        child: FutureBuilder<Ingredient>(
          future: ingredient,
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
                    'Description:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.description ?? 'N/A'),
                  const SizedBox(height: 16.0),
                  Text(
                    'Type:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.type),
                  const SizedBox(height: 16.0),
                  Text(
                    'Supplier:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Text(snapshot.data!.supplier ?? 'N/A'),
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