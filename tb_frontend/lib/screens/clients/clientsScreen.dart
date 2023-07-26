import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tb_frontend/models/client.dart';
import 'clientDetailsScreen.dart';
import 'clientItem.dart';
import 'createClientScreen.dart';
import 'dart:async';

/// This class is used to display the clients screen
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

/// this class is used to manage the state of the clients screen.
class _ClientsScreenState extends State<ClientsScreen> {
  late Future<List<Client>> clients;
  List<Client> localClients = [];
  List<Client> searchedClients = [];
  TextEditingController editingController = TextEditingController();
  bool _showSearchBar = false;

  /// This function is used to initialize the state of the clients screen.
  /// It fetches the clients from the backend.
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
    }).catchError((error) {
      fetchClientsLocally().then((value) => {
            setState(() {
              localClients.addAll(value);
              searchedClients.addAll(value);
            })
          });
    });
  }

  /// This function is used to select a client.
  /// It navigates to the client details screen.
  /// If the client was edited, it updates the client screen.
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

  /// This function is used to create a client.
  /// It navigates to the create client screen.
  /// If the client was created, it updates the client screen.
  void _createClient() async {
    final newClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateClientScreen('Create Client'),
      ),
    );
    if (newClient != null) {
      setState(() {
        localClients.add(newClient);
        searchedClients.add(newClient);
      });
    }
  }

  /// This function is used to delete a client from the backend.
  /// If the client was deleted, it updates the client screen and shows a snackbar.
  /// If the client could not be deleted, it shows a snackbar.
  void _deleteClient(Client client) async {
    final response = await deleteClient(client.id).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'You don\'t have the permission to delete this client',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
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

  /// This function is used to filter the clients by name with the search bar.
  void _filterSearchResults(String query) {
    setState(() {
      searchedClients = localClients
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// This function is used to refresh the clients screen.
  /// It fetches the clients from the backend.
  Future _refreshClients() async {
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

  /// This function is used to build the clients screen.
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
                        showDialog(
                          context: context,
                          /// A dialog is shown to confirm the deletion of the client.
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
