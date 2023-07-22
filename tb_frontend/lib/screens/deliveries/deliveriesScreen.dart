
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/delivery.dart';
import 'createDeliveryScreen.dart';
import 'deliveryDetailsScreen.dart';
import 'deliveryItem.dart';


class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

class _DeliveriesScreenState extends State<DeliveriesScreen> {

  late Future<List<Delivery>> deliveries;
  List<Delivery> localDeliveries = [];
  List<Delivery> searchedDeliveries = [];

  bool _showSearchBar = false;

  TextEditingController editingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    deliveries = fetchDeliveries();
    deliveries.then((value) => {
      localDeliveries.addAll(value),
      searchedDeliveries.addAll(value),
      /*localDeliveries.forEach((element) {
        element.status = "ok";
        element.remoteId = 23;
        insertDelivery(element);
      })*/
    });
  }
  void _selectDelivery(BuildContext context, Delivery delivery) async {
    final updatedDelivery = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => DeliveryDetailsScreen(delivery),
      ),
    );
    if(updatedDelivery != null) {
      setState(() {
        localDeliveries.remove(delivery);
        localDeliveries.add(updatedDelivery);
        searchedDeliveries.remove(delivery);
        searchedDeliveries.add(updatedDelivery);
      });
    }
  }

  void _createDelivery() async{
    final newDelivery = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateDeliveryScreen('Create Delivery'),
      ),
    );
    if(newDelivery != null) {
      setState(() {
        //deliveries = fetchDeliveries();
        localDeliveries.add(newDelivery);
        searchedDeliveries.add(newDelivery);
        /*newDelivery.status = "new";
        insertDelivery(newDelivery);*/
      });
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      searchedDeliveries = localDeliveries
          .where((delivery) => delivery.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future _refreshDeliveries() async {
    log("=================================REFRESHING CLIENTS=================================");
    setState(() {
      deliveries = fetchDeliveries();
      deliveries.then((value) => {
        localDeliveries.clear(),
        localDeliveries.addAll(value),
        searchedDeliveries.clear(),
        searchedDeliveries.addAll(value)
      });
    });
  }

  void _deleteDelivery(Delivery delivery) async {
    log("=================================DELETING CLIENT=================================");
    final statusCode = await deleteDelivery(delivery.id).catchError((error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message,
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.red,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
        setState(() {});
        return HttpStatus.forbidden;
      }
    });
    if (statusCode == HttpStatus.noContent) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Delivery deleted successfully.",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Colors.green,
            showCloseIcon: true,
            closeIconColor: Colors.white,
          ),
        );
      }
      setState(() {
        localDeliveries.remove(delivery);
        searchedDeliveries.remove(delivery);
      });
    }
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

    log("=================================BINDING CLIENTS SCREEN===============================");
    //late Future<List<Delivery>> deliveries = fetchDeliveries();
    Widget content = FutureBuilder<List<Delivery>>(
      future: deliveries,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshDeliveries,//_refreshDeliveries,
            child: Column(
              children: [
                if (_showSearchBar) searchBar,
                Expanded(
                  child: ListView.builder(
                    itemCount: searchedDeliveries.length,
                    itemBuilder: (context, index) => Dismissible(
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        // onRemoveExpense(expenses[index]);
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text("Delete Delivery"),
                            content: const Text(
                                "Are you sure you want to delete this delivery?"),
                            actions: [
                              TextButton(
                                child: const Text("No"),
                                onPressed: () {
                                  setState(() {
                                    DeliveryItem(searchedDeliveries[index], _selectDelivery);
                                    Navigator.of(ctx).pop();
                                  });
                                },
                              ),
                              TextButton(
                                child: const Text("Yes"),
                                onPressed: () {
                                  _deleteDelivery(searchedDeliveries[index]);
                                  Navigator.of(ctx).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: DeliveryItem(searchedDeliveries[index], _selectDelivery),
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
        title: const Text("Deliveries"),
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
              _createDelivery();
            },
          ),
        ],
      ),
      body: content,
    );
  }
}
