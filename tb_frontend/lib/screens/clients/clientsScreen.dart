import 'dart:developer';
import 'dart:io';

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
  List<Client> searchedClients = [];
  TextEditingController editingController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    clients = fetchClients();
    clients.then((value) {
      setState(() {
        localClients.addAll(value);
        searchedClients.addAll(value);
      });

      if (value.isEmpty) {
        fetchClientsLocally().then((value) => {
          setState(() {
            localClients.addAll(value);
            searchedClients.addAll(value);
          })
        });
      }
      //localClients.addAll(value);
      //searchedClients.addAll(value);
    }).catchError((error) {
      //log("=================================ERROgxdR=======================");
      //log(error.toString());
      fetchClientsLocally().then((value) => {
            setState(() {
              localClients.addAll(value);
              searchedClients.addAll(value);
            })
          });
      /*clients.then((value) => {
      localClients.addAll(value),
      searchedClients.addAll(value),
        log(localClients.toString()),
        log(searchedClients.toString())
      })
      });*/
    });
  }

  void _selectClient(BuildContext context, Client client) async {
    final updatedClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ClientDetailsScreen(client),
      ),
    );
    if (updatedClient != null) {
      setState(() {
        localClients.remove(client);
        localClients.add(updatedClient);
        searchedClients.remove(client);
        searchedClients.add(updatedClient);
      });
    }
  }

  void _createClient() async {
    final newClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateClientScreen('Create Client'),
      ),
    );
    if (newClient != null) {
      setState(() {
        //clients = fetchClients();
        /*newClient.status = "new";
        createClientLocally(newClient);*/
        localClients.add(newClient);
        searchedClients.add(newClient);
      });
    }
  }

  void _deleteClient(Client client) async {
    final response = await deleteClient(client.id).catchError((error) {
      log("=================================ERROR DELETING CLIENT=================================");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You don\'t have permission to delete this client',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
      // TODO: workaround for now, need to fix.
      setState(() {});
    });
    if (response.statusCode == HttpStatus.noContent) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Client deleted successfully",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
      setState(() {
        localClients.remove(client);
        searchedClients.remove(client);
      });
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      searchedClients = localClients
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future _refreshClients() async {
    log("=================================REFRESHING CLIENTS=================================");
    setState(() {
      clients = fetchClients();
      clients.then((value) => {
        localClients.clear(),
        localClients.addAll(value),
        searchedClients.clear(),
        searchedClients.addAll(value)
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget searchBar = Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (value) {
          _filterSearchResults(value);
        },
        controller: editingController,
        decoration: const InputDecoration(
          labelText: "Search",
          hintText: "Search",
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );

    Widget content = FutureBuilder<List<Client>>(
      future: clients,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshClients, //_refreshClients,
            child: Column(
              children: [
                if (_showSearchBar) searchBar,
                Expanded(
                  child: ListView.builder(
                    itemCount: searchedClients.length,
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
                                    ClientItem(
                                        searchedClients[index], _selectClient);
                                    Navigator.of(ctx).pop();
                                  });
                                },
                              ),
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  _deleteClient(searchedClients[index]);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: ClientItem(searchedClients[index], _selectClient),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Clients"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
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
