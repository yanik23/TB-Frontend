import 'package:flutter/material.dart';
import '../../models/client.dart';
import 'createClientScreen.dart';


/// this class is used to display the details of a client
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class ClientDetailsScreen extends StatefulWidget {
  final Client tempClient;

  const ClientDetailsScreen(this.tempClient, {super.key});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

/// This class is used to manage the state of the client details screen
class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  late Future<Client> client;

  /// This function is used to initialize the state of the client details screen
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    client = fetchClient(widget.tempClient.id);
  }

  /// This function is used to edit a client
  /// it navigates to the create client screen
  /// if the client was edited, it updates the client details screen
  void _editClient(Client c) async {
    final newClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CreateClientScreen('Edit Client',client: c),
      ),
    );
    if (newClient != null) {
      setState(() {
        client = fetchClient(newClient.id);
      });
    }
  }

  /// This function is used to build the client details screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
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
      /// This function is used to build the client details screen
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(client);
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Client>(
            future: client,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final localClient = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localClient.name,
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
                    Text('${localClient.addressName} ${localClient.addressNumber}'),
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
                    Text('${localClient.zipCode} ${localClient.city}'),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                        onPressed: () {
                          _editClient(localClient);
                        },
                        child: const Text('Edit Client')),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),),
      ),
    );
  }
}
