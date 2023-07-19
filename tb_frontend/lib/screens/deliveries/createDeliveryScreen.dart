import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:tb_frontend/dto/dishForDeliveryDTO.dart';
import 'package:tb_frontend/models/dish.dart';
import 'package:tb_frontend/screens/deliveries/addClientToDeliveryScreen.dart';
import '../../models/client.dart';
import '../../models/delivery.dart';
import '../../utils/constants.dart';
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

  final List<Client> _clients = [];
  final List<DishCheck> _dishes = [];
  List<DishCheck> selectedDishes = [];

  final RegExp _descriptionRegExp = RegExp(descriptionRegexPattern);

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

  void _createOrUpdateDelivery() {
    // Create a new delivery object with the input data
    Delivery newDelivery = Delivery(
      _id,
      _username,
      _clientName,
      _date,
      _deliveryDetails,
      selectedDishes.map((e) => DishForDeliveryDTO(e.id, e.name, 0, e.quantityRemained ,e.quantityDelivered)).toList(),
    );

    //Future<Delivery> resultDelivery = createDelivery(newDelivery);
    Future<Delivery> resultDelivery;
    String snackBarMessage = '';
    if(widget.delivery == null) {
      resultDelivery = createDelivery(newDelivery);
      snackBarMessage = 'Delivery created succesfully';
    } else {
      resultDelivery = updateDelivery(newDelivery);
      snackBarMessage = 'Delivery updated succesfully';
    }
    resultDelivery.then((delivery) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(snackBarMessage, textAlign: TextAlign.center),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      Navigator.of(context).pop(delivery);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message, textAlign: TextAlign.center),
          backgroundColor: Colors.red,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
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
                initialValue: _deliveryDetails,
                maxLength: 255,
                validator: (value) {
                  if (!_descriptionRegExp.hasMatch(value!)) {
                    return 'Please enter a valid delivery details';
                  }
                  return null;
                },
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
                    formatter.format(_date),
                       /* ? 'No date selected'
                        : formatter.format(_date!),*/
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
                    _clientName.isEmpty
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
                    _createOrUpdateDelivery();
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
