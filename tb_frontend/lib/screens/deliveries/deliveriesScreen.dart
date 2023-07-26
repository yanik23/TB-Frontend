
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/delivery.dart';
import 'createDeliveryScreen.dart';
import 'deliveryDetailsScreen.dart';
import 'deliveryItem.dart';


/// This class is used to display the deliveries screen
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class DeliveriesScreen extends StatefulWidget {
  const DeliveriesScreen({super.key});

  @override
  State<DeliveriesScreen> createState() => _DeliveriesScreenState();
}

/// This class is used to manage the state of the deliveries screen
class _DeliveriesScreenState extends State<DeliveriesScreen> {

  // the list of deliveries fetched from the backend
  late Future<List<Delivery>> deliveries;
  // the list of deliveries stored locally
  List<Delivery> localDeliveries = [];
  // the list of deliveries searched by the user
  List<Delivery> searchedDeliveries = [];
  // show search bar
  bool _showSearchBar = false;
  // editing controller for the search bar
  TextEditingController editingController = TextEditingController();


  /// This function is used to initialize the state of the deliveries screen
  /// It fetches the deliveries from the backend.
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

  /// This function is used to select a delivery.
  /// It navigates to the delivery details screen.
  /// If the delivery was edited, it updates the delivery details screen
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

  /// This function is used to create a delivery.
  /// It navigates to the create delivery screen.
  /// If the delivery was created, it updates the deliveries screen
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

  /// This function is used to filter the deliveries by the search query.
  void _filterSearchResults(String query) {
    setState(() {
      searchedDeliveries = localDeliveries
          .where((delivery) => delivery.username.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  /// This function is used to refresh the deliveries screen.
  /// It fetches the deliveries from the backend to refresh the list.
  Future _refreshDeliveries() async {
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

  /// This function is used to delete a delivery.
  /// It deletes the delivery from the backend.
  /// If the delivery was deleted, it updates the deliveries screen and shows a snackbar.
  /// If the delivery could not be deleted, it shows a snackbar with an error message.
  void _deleteDelivery(Delivery delivery) async {
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


  /// This function is used to build the deliveries screen
  @override
  Widget build(BuildContext context) {
    /// This widget is used to display the search bar
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

     /// This widget is used to display the deliveries
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
