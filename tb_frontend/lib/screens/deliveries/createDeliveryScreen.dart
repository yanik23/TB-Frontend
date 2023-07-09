import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/delivery.dart';
import 'package:intl/intl.dart';


//final formatter = DateFormat.yMd();
final formatter = DateFormat('dd/MM/yyyy');

class CreateDeliveryScreen extends StatefulWidget {
  final Delivery? delivery;
  const CreateDeliveryScreen({this.delivery, super.key});

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _username = '';
  String _clientName = '';
  late DateTime _date = DateTime.now();
  String _deliveryDetails = '';
  int _quantityRemained = 0;
  int _quantityDelivered = 0;


  @override
  void initState() {
    if (widget.delivery != null) {
      super.initState();
      setState(() {
        _id = widget.delivery!.id;
        _username = widget.delivery!.username;
        _clientName = widget.delivery!.clientName;

      });
    }
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if(value != null) {
        setState(() {
          _date = value;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery details (Optional)',
                  hintText: 'Enter some delivery details',
                ),
                initialValue: _username,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid delivery details';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _date == null
                        ? 'No date selected'
                        : formatter.format(_date!),
                  ),
                  IconButton(
                    onPressed: _showDatePicker,
                    icon: const Icon(Icons.calendar_month),
                  ),
                ],
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity remained from last time',
                    hintText: 'Enter the quantity remained from last time'),
                initialValue: _quantityRemained == 0 ? '' : _quantityRemained.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid quantity remained';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantityRemained = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity delivered',
                    hintText: 'Enter the quantity delivered'),
                initialValue: _quantityDelivered == 0 ? '' : _quantityDelivered.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid quantity delivered';
                  }
                  return null;
                },
                onSaved: (value) {
                  _quantityDelivered = int.parse(value!);
                },
              ),

              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // Create a new delivery object with the input data
                    Delivery newDelivery = Delivery(
                      _id,
                      _username,
                      _clientName,
                      _date,
                      _deliveryDetails,
                      []
                    );
                    // Do something with the new delivery object (e.g., save to database)
                    try {} catch (e) {
                      log('Delivery not created');
                    }
                    try {} catch (e) {
                      log('=======================Delivery not created=======================');
                    }

                    //Future<Delivery> resultDelivery = createDelivery(newDelivery);
                    Future<Delivery> resultDelivery;

                    if(widget.delivery != null) {
                      resultDelivery = updateDelivery(newDelivery);
                    } else {
                      resultDelivery = createDelivery(newDelivery);
                    }
                    resultDelivery
                        .whenComplete(() => Navigator.of(context).pop(resultDelivery));

                    //Navigator.of(context).pop(delivery);

                    // Go back to the previous screen
                  }
                },
              ),
            ],
          ),
        ),
        //],
      ),
      //),
    );
  }
}
