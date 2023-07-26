

import 'package:flutter/material.dart';
import '../../models/ingredient.dart';
import 'createIngredientScreen.dart';

/// This class is used to display the ingredient details screen of the application.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class IngredientDetailsScreen extends StatefulWidget {

  // ingredient to display
  final Ingredient tempIngredient;

  const IngredientDetailsScreen(this.tempIngredient, {super.key});

  @override
  State<IngredientDetailsScreen> createState() => _IngredientDetailsScreenState();
}

/// This class is used to manage the state of the ingredient details screen.
class _IngredientDetailsScreenState extends State<IngredientDetailsScreen> {
  late Future<Ingredient> ingredient;

  /// This function is used to initialize the state of the ingredient details screen.
  /// It fetches the ingredient from the backend.
  @override
  void initState() {
    super.initState();
    ingredient = fetchIngredient(widget.tempIngredient.id);
  }

  /// This function is used to edit an ingredient.
  /// It navigates to the create ingredient screen.
  /// If the ingredient was edited, it updates the ingredient details screen.
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

  /// This function is used to build the ingredient details screen.
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
                title: const Text("QR Code"),
                content: const Text("QR code not implemented yet"),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              );
            },
          ),
        ],
      ),

      /// Used to update the ingredient list when the ingredient was edited.
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
                    }, child: const Text('Edit Ingredient')),
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