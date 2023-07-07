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
  List<Client> localClients = [];

  @override
  void initState() {
    super.initState();
    clients = fetchClients();
    clients.then((value) => {
      localClients.addAll(value),
      localClients.forEach((element) {
        element.status = "ok";
        element.remoteId = 23;
        insertClient(element);
      })
    });
  }
  void _selectClient(BuildContext context, Client client) async {
    final updatedClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ClientDetailsScreen(client),
      ),
    );
    if(updatedClient != null) {
      setState(() {
        localClients.remove(client);
        localClients.add(updatedClient);
      });
    }
  }

  void _createClient() async{
    final newClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateClientScreen(),
      ),
    );
    if(newClient != null) {
      setState(() {
        //clients = fetchClients();
        localClients.add(newClient);
        newClient.status = "new";
        insertClient(newClient);
      });
    }
  }

  Future _refreshClients() async {
    log("=================================REFRESHING CLIENTS=================================");
    setState(() {
      clients = fetchClients();
      clients.then((value) => {
        localClients.clear(),
        localClients.addAll(value)
      });
    });
  }

  void _deleteClient(Client client) async {
    log("=================================DELETING CLIENT=================================");
    deleteClient(client.id);
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
              itemCount: localClients.length,
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
                              ClientItem(localClients[index], _selectClient);
                              Navigator.of(ctx).pop();
                            });
                          },
                        ),
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            deleteClient(localClients[index].id);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: ClientItem(localClients[index], _selectClient),
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
