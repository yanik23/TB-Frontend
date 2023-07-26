import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';

import '../../models/delivery.dart';
import 'createDeliveryScreen.dart';



class DeliveryDetailsScreen extends StatefulWidget {
  final Delivery tempDelivery;

  const DeliveryDetailsScreen(this.tempDelivery, {super.key});

  @override
  State<DeliveryDetailsScreen> createState() => _DeliveryDetailsScreenState();
}

class _DeliveryDetailsScreenState extends State<DeliveryDetailsScreen> {
  late Future<Delivery> delivery;
  //Delivery localDelivery

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delivery = fetchDelivery(widget.tempDelivery.id);
  }

  void _editDelivery(Delivery c) async {
    final newDelivery = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => CreateDeliveryScreen('Edit Delivery', delivery: c),
      ),
    );
    if (newDelivery != null) {
      setState(() {
        delivery = fetchDelivery(newDelivery.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
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
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop(delivery);
          return true;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<Delivery>(
            future: delivery,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final localDelivery = snapshot.data!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery nr. ${localDelivery.id}',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Delivered by:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDelivery.username),
                    const SizedBox(height: 16.0),
                    Text(
                      'Delivered to:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDelivery.clientName),
                    const SizedBox(height: 16.0),
                    Text(
                      'Delivery date:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(formatter.format(localDelivery.deliveryDate)),
                    const SizedBox(height: 16.0),
                    Text(
                      'Delivery details:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(localDelivery.details??"N/A"),
                    const SizedBox(height: 16.0),
                    Text(
                      'Dishes delivered:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxHeight: 250.0),
                      child: Scrollbar(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: localDelivery.dishes?.length,
                          itemBuilder: (context, index) =>

                                Column(
                                  children: [
                                    Text(localDelivery.dishes?[index].name ?? 'N/A', style: TextStyle(
                                      fontSize: 18.0,
                                      //fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),),
                                    Container(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.monetization_on, color: Colors.orangeAccent),
                                          Text(localDelivery.dishes?[index].price.toString() ?? 'N/A'),
                                          const Spacer(),
                                          const Text("Remained: "),
                                          Text(localDelivery.dishes?[index].quantityRemained.toString() ?? 'N/A'),
                                          const Spacer(),
                                          const Text("Delivered: "),
                                          Text(localDelivery.dishes?[index].quantityDelivered.toString() ?? 'N/A'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16.0),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32.0),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            _editDelivery(localDelivery);
                          },
                          child: const Text('Edit Delivery')),
                    ),
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
