import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:tb_frontend/dto/dishForDeliveryDTO.dart';
import 'package:tb_frontend/models/dish.dart';
import 'package:tb_frontend/models/ingredient.dart';
import 'package:tb_frontend/screens/deliveries/addClientToDeliveryScreen.dart';

import '../../models/client.dart';
import '../../models/delivery.dart';
import 'package:intl/intl.dart';

import '../../utils/secureStorageManager.dart';
import 'addDishesToDeliveryScreen.dart';




class DishCheck {
  int id;
  String name;
  bool isChecked;
  int quantityRemained;
  int quantityDelivered;

  DishCheck(this.id, this.name, this.isChecked, this.quantityRemained, this.quantityDelivered);
}
//final formatter = DateFormat.yMd();
//final formatter = DateFormat('dd/MM/yyyy');

class CreateDeliveryScreen extends StatefulWidget {
  final Delivery? delivery;

  const CreateDeliveryScreen({this.delivery, super.key});

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _username = "";
  String _clientName = '';
  late DateTime _date = DateTime.now();
  String? _deliveryDetails = '';

  List<Client> _clients = [];
  //Client? selectedClient;
  //String selectedClient = '';


  List<DishCheck> _dishes = [];
  List<DishCheck> selectedDishes = [];


  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadClients();
    _loadDishes();
    if (widget.delivery != null) {
      setState(() {
        _id = widget.delivery!.id;
        _username = widget.delivery!.username;
        _clientName = widget.delivery!.clientName;
        _deliveryDetails = widget.delivery!.details;
        // TODO check date
        _date = widget.delivery!.deliveryDate;
        //selectedClient= widget.delivery!.clientName;
        selectedDishes = widget.delivery!.dishes!.map((e) => DishCheck(e.id, e.name, true, e.quantityRemained, e.quantityDelivered)).toList();

      });
    }
  }

  void _loadUser() async {
    final username = await SecureStorageManager.read('KEY_USERNAME');
    if(username != null) {
      setState(() {
        _username = username;
      });
    }
  }

  void _loadClients() async {
    fetchClients().then((value) {
      setState(() {
        _clients.addAll(value);
      });
    });
  }

  void _loadDishes() async {
    fetchDishes().then((value) {
      setState(() {
        for(var dish in value) {
          _dishes.add(DishCheck(dish.id, dish.name, false, 0, 0));
        }
      });
    });
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: widget.delivery?.deliveryDate ?? DateTime.now(),
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


  void _addClientToDelivery() async {
    final newClient = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddClientToDeliveryScreen(_clients, _clientName)
      ),
    );
    if (newClient != null) {
      setState(() {
        _clientName = newClient;
      });
    }
  }

  void _addDishesToDelivery() async {
    final newDishes = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddDishesToDeliveryScreen(_dishes, selectedDishes),
      ),
    );
    if (newDishes != null) {
      setState(() {
        selectedDishes = newDishes;
      });
    }
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
                initialValue: _deliveryDetails,
                /*validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid delivery details';
                  }
                  return null;
                },*/
                onSaved: (value) {
                  _deliveryDetails = value!;
                },
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('Delivery date : '),
                  const Spacer(),
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
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Text(
                    _clientName == null
                        ? 'No client selected'
                        : 'Delivery to : $_clientName',
                  ),
                  const Spacer(),
                  ElevatedButton(onPressed: () {
                    _addClientToDelivery();
                  }, child: const Text('Add Client')),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Text('List of dishes :'),
                  const Spacer(),
                  ElevatedButton(onPressed: () {
                    _addDishesToDelivery();
                  }, child: const Text('Add Dishes')),
                ],
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
                      selectedDishes.map((e) => DishForDeliveryDTO(e.id, e.name, 0, e.quantityRemained ,e.quantityDelivered)).toList(),
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
