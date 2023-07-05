import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/models/client.dart';

import 'clientDetailsScreen.dart';
import 'clientItem.dart';
import 'createClientScreen.dart';
import 'dart:async';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {

  late Future<List<Client>> clients;

  @override
  void initState() {
    super.initState();
    clients = fetchClients();
  }
  void _selectClient(BuildContext context, Client client) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const ClientDetailsScreen(),
      ),
    );
  }

  void _createClient() async{
    final newClient = Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateClientScreen(),
      ),
    );
    if(newClient != null) {
      log("=================================NEW CLIENT CREATED=================================");
      setState(() {
        clients = fetchClients();
      });
    }
  }

  Future _refreshClients() async {
    setState(() {
      clients = fetchClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    log("=================================BINDING CLIENTS SCREEN===============================");
    //late Future<List<Client>> clients = fetchClients();
    Widget content = FutureBuilder<List<Client>>(
      future: clients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshClients,//_refreshClients,
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  // onRemoveExpense(expenses[index]);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Delete Client"),
                      content: const Text(
                          "Are you sure you want to delete this client?"),
                      actions: [
                        TextButton(
                          child: const Text("No"),
                          onPressed: () {
                            setState(() {
                              ClientItem(snapshot.data![index], _selectClient);
                              Navigator.of(ctx).pop();
                            });
                          },
                        ),
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            deleteClient(snapshot.data![index].id);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: ClientItem(snapshot.data![index], _selectClient),
              ),
            ),
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
              _createClient();
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
