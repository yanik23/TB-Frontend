import 'dart:developer';

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

  @override
  void initState() {
    super.initState();
    deliveries = fetchDeliveries();
    deliveries.then((value) => {
      localDeliveries.addAll(value),
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
      });
    }
  }

  void _createDelivery() async{
    final newDelivery = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const CreateDeliveryScreen(),
      ),
    );
    if(newDelivery != null) {
      setState(() {
        //deliveries = fetchDeliveries();
        localDeliveries.add(newDelivery);
        /*newDelivery.status = "new";
        insertDelivery(newDelivery);*/
      });
    }
  }

  Future _refreshDeliveries() async {
    log("=================================REFRESHING CLIENTS=================================");
    setState(() {
      deliveries = fetchDeliveries();
      deliveries.then((value) => {
        localDeliveries.clear(),
        localDeliveries.addAll(value)
      });
    });
  }

  void _deleteDelivery(Delivery delivery) async {
    log("=================================DELETING CLIENT=================================");
    deleteDelivery(delivery.id);
    setState(() {
      deliveries = fetchDeliveries();
    });
  }


  @override
  Widget build(BuildContext context) {
    log("=================================BINDING CLIENTS SCREEN===============================");
    //late Future<List<Delivery>> deliveries = fetchDeliveries();
    Widget content = FutureBuilder<List<Delivery>>(
      future: deliveries,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return RefreshIndicator(
            onRefresh: _refreshDeliveries,//_refreshDeliveries,
            child: ListView.builder(
              itemCount: localDeliveries.length,
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
                              DeliveryItem(localDeliveries[index], _selectDelivery);
                              Navigator.of(ctx).pop();
                            });
                          },
                        ),
                        TextButton(
                          child: const Text("Yes"),
                          onPressed: () {
                            deleteDelivery(localDeliveries[index].id);
                            Navigator.of(ctx).pop();
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: DeliveryItem(localDeliveries[index], _selectDelivery),
              ),
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
            onPressed: () {},
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
