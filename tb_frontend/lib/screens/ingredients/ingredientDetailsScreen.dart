

import 'package:flutter/material.dart';

import '../../models/ingredient.dart';
import 'createIngredientScreen.dart';

class IngredientDetailsScreen extends StatefulWidget {
  //static const routeName = '/dish-details-screen';

  final Ingredient tempIngredient;

  const IngredientDetailsScreen(this.tempIngredient, {super.key});

  @override
  State<IngredientDetailsScreen> createState() => _IngredientDetailsScreenState();
}

class _IngredientDetailsScreenState extends State<IngredientDetailsScreen> {
  late Future<Ingredient> ingredient;

  @override
  void initState() {
    super.initState();
    ingredient = fetchIngredient(widget.tempIngredient.id);
  }

  
  void _editIngredient(Ingredient i) async {
    final updatedIngredient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CreateIngredientScreen('Edit Ingredient', ingredient: i),
      ),
    );
    if(updatedIngredient != null) {
      setState(() {
        ingredient = fetchIngredient(updatedIngredient.id);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
              AlertDialog(
                title: Text("QR Code"),
                content: Text("QR code not implemented yet"),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              );
              /*ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('QR code not implemented yet'),
                ),
              );*/
            },
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(ingredient);
          return true;
        },
        child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Ingredient>(
          future: ingredient,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(snapshot.data!.type.toString().split('.').last),
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

                  Center(
                    child: ElevatedButton(onPressed: () {
                      _editIngredient(snapshot.data!);
                    }, child: const Text('Edit')),
                  ),

                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const Center(child: CircularProgressIndicator());
          },
        )
      ),
      ),
    );
  }
}