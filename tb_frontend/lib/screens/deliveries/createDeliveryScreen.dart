import 'package:flutter/material.dart';
import 'package:tb_frontend/dto/dishForDeliveryDTO.dart';
import 'package:tb_frontend/models/dish.dart';
import 'package:tb_frontend/screens/deliveries/addClientToDeliveryScreen.dart';
import '../../models/client.dart';
import '../../models/delivery.dart';
import '../../utils/constants.dart';
import '../../utils/secureStorageManager.dart';
import '../welcomeScreen.dart';
import 'addDishesToDeliveryScreen.dart';

/// This class is used to represent a dish with a checkbox.
class DishCheck {
  int id;
  String name;
  bool isChecked;
  int quantityRemained;
  int quantityDelivered;

  DishCheck(this.id, this.name, this.isChecked, this.quantityRemained,
      this.quantityDelivered);
}

/// This class is used to display the create delivery screen
class CreateDeliveryScreen extends StatefulWidget {
  // the delivery to be updated. If null, we create a new delivery
  final Delivery? delivery;
  // the title of the screen
  final String title;

  const CreateDeliveryScreen(this.title, {this.delivery, super.key});

  @override
  State<CreateDeliveryScreen> createState() => _CreateDeliveryScreenState();
}

/// This class is used to manage the state of the create delivery screen
class _CreateDeliveryScreenState extends State<CreateDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();

  // initial values for the form fields
  int _id = 0;
  String _username = "";
  String _clientName = '';
  late DateTime _date = DateTime.now();
  String? _deliveryDetails = '';

  // the list of clients that can be selected
  final List<Client> _clients = [];
  // the list of dishes that can be selected
  final List<DishCheck> _dishes = [];
  // the list of dishes selected by the user
  List<DishCheck> selectedDishes = [];

  // regex patterns for validation
  final RegExp _descriptionRegExp = RegExp(descriptionRegexPattern);

  /// This function is used to initialize the state of the create delivery screen
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
        selectedDishes = widget.delivery!.dishes!
            .map((e) => DishCheck(
                e.id, e.name, true, e.quantityRemained, e.quantityDelivered))
            .toList();
      });
    }
  }

  /// This function is used to load the user from the secure storage
  void _loadUser() async {
    final username = await SecureStorageManager.read('KEY_USERNAME');
    if (username != null) {
      setState(() {
        _username = username;
      });
    }
  }

  /// This function is used to load the clients from the backend
  void _loadClients() async {
    fetchClients().then((value) {
      setState(() {
        _clients.addAll(value);
      });
    });
  }

  /// This function is used to load the dishes from the backend
  void _loadDishes() async {
    fetchDishes().then((value) {
      setState(() {
        for (var dish in value) {
          _dishes.add(DishCheck(dish.id, dish.name, false, 0, 0));
        }
      });
    });
  }

  /// This function is used to show the date picker
  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: widget.delivery?.deliveryDate ?? DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value != null) {
        setState(() {
          _date = value;
        });
      }
    });
  }

  /// This function is used to add a client to the delivery
  /// It navigates to the add client to delivery screen
  /// If a client was added, it updates the client name
  void _addClientToDelivery() async {
    final newClient = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) =>
              AddClientToDeliveryScreen(_clients, _clientName)),
    );
    if (newClient != null) {
      setState(() {
        _clientName = newClient;
      });
    }
  }

  /// This function is used to add dishes to the delivery
  /// It navigates to the add dishes to delivery screen
  /// If dishes were added, it updates the list of selected dishes
  void _addDishesToDelivery() async {
    final newDishes = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            AddDishesToDeliveryScreen(_dishes, selectedDishes),
      ),
    );
    if (newDishes != null) {
      setState(() {
        selectedDishes = newDishes;
      });
    }
  }

  /// This function is used to create or update a delivery
  void _createOrUpdateDelivery() {
    // Create a new delivery object with the input data
    Delivery newDelivery = Delivery(
      _id,
      _username,
      _clientName,
      _date,
      _deliveryDetails,
      selectedDishes
          .map((e) => DishForDeliveryDTO(
              e.id, e.name, 0, e.quantityRemained, e.quantityDelivered))
          .toList(),
    );

    /// if the delivery is null, we create a new delivery, else we update the delivery
    Future<Delivery> resultDelivery;
    String snackBarMessage = '';
    if (widget.delivery == null) {
      resultDelivery = createDelivery(newDelivery);
      snackBarMessage = 'Delivery created successfully';
    } else {
      resultDelivery = updateDelivery(newDelivery);
      snackBarMessage = 'Delivery updated successfully';
    }

    /// if the delivery was created or updated successfully, we show a snackbar
    /// and navigate back to the deliveries screen with the updated or created delivery
    /// else we show a snackbar with the error message
    resultDelivery.then((delivery) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarMessage, textAlign: TextAlign.center),
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

  /// This function is used to build the create delivery screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
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
                    Text(
                      'Delivery date : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                          color: kColorScheme.primary),
                    ),
                    const Spacer(),
                    Text(
                      formatter.format(_date),
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
                      'Delivered to : ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                          color: kColorScheme.primary),
                    ),
                    const Spacer(),
                    /// add client button
                    ElevatedButton(
                        onPressed: () {
                          _addClientToDelivery();
                        },
                        child: const Text('Add Client')),
                  ],
                ),
                Text(
                  _clientName.isEmpty ? 'No client selected' : _clientName,
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Text(
                      'List of dishes :',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16.0,
                          color: kColorScheme.primary),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          _addDishesToDelivery();
                        },
                        child: const Text('Add Dishes')),
                  ],
                ),

                const SizedBox(height: 16.0),

                /// This widget displays the list of selected dishes for a delivery
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxHeight: 250.0),
                  child: Scrollbar(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedDishes.length,
                      itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              selectedDishes[index].name ?? 'N/A',
                              style: TextStyle(
                                fontSize: 18.0,
                                //fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.recycling,
                                    color: Colors.orangeAccent),
                                const SizedBox(width: 8.0),
                                const Text("Remained: "),
                                Text(selectedDishes[index]
                                        .quantityRemained
                                        .toString() ??
                                    'N/A'),
                                const Spacer(),
                                const Icon(Icons.delivery_dining,
                                    color: Colors.orangeAccent),
                                const SizedBox(width: 8.0),
                                const Text("Delivered: "),
                                Text(selectedDishes[index]
                                        .quantityDelivered
                                        .toString() ??
                                    'N/A'),
                              ],
                            ),
                            const SizedBox(height: 16.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _createOrUpdateDelivery();
                    }
                  },
                  child: const Text('Save Delivery'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
