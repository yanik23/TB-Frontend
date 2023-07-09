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
  List<Client> searchedClients = [];
  TextEditingController editingController = TextEditingController();
  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    clients = fetchClients();
    clients.then((value) => {
      localClients.addAll(value),
      searchedClients.addAll(value)
      /*localClients.forEach((element) {
        element.status = "ok";
        element.remoteId = 23;
        insertClient(element);
      })*/
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
        searchedClients.remove(client);
        searchedClients.add(updatedClient);
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
        searchedClients.add(newClient);
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
        localClients.addAll(value),
        searchedClients.clear(),
        searchedClients.addAll(value)
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


  /*void _filterSearchResults(String query) {
    List<Client> dummySearchList = [];
    dummySearchList.addAll(localClients);
    if(query.isNotEmpty) {
      List<Client> dummyListData = [];
      dummySearchList.forEach((item) {
        if(item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        localClients.clear();
        localClients.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        localClients.clear();
        localClients.addAll(dummySearchList);
      });
    }
  }*/

  void _filterSearchResults(String query) {
    setState(() {
      searchedClients = localClients
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
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
            onRefresh: _refreshClients,//_refreshClients,
            child: Column(
              children: [
                if(_showSearchBar) searchBar,

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
                                    ClientItem(searchedClients[index], _selectClient);
                                    Navigator.of(ctx).pop();
                                  });
                                },
                              ),
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  deleteClient(searchedClients[index].id);
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
