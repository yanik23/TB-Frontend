

import 'package:flutter/material.dart';
import 'package:tb_frontend/models/client.dart';

import 'clientDetailsScreen.dart';
import 'clientItem.dart';
import 'createClientScreen.dart';

class ClientsScreen extends StatelessWidget {

  late Future<List<Client>> clients = fetchClients();

  ClientsScreen({super.key});


  void _selectClient(BuildContext context, Client client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ClientDetailsScreen(),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    Widget content = FutureBuilder<List<Client>>(
      future: clients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ClientItem(snapshot.data![index], _selectClient);
            },
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const CircularProgressIndicator();
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Clients"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const CreateClientScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: content,
    );
  }
}

