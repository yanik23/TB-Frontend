



import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/dish.dart';
import '../welcomeScreen.dart';


/*class DishCheck {
  String name = "";
  bool check = false;
  DishCheck({this.check = false});
}*/
class AddClientToDeliveryScreen extends StatefulWidget {

  List<Client> clients;
  Client? selectedClient;

  AddClientToDeliveryScreen(this.clients, this.selectedClient, {super.key});

  @override
  State<AddClientToDeliveryScreen> createState() => _AddClientToDeliveryScreenState();
}


class _AddClientToDeliveryScreenState extends State<AddClientToDeliveryScreen> {

  //Dish dish = Dish();
  bool _showSearchBar = false;


  void _onAddPressed() {
    Navigator.of(context).pop(widget.selectedClient);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add client to delivery'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _showSearchBar = !_showSearchBar;
              });
            },
          ),
        ],
      ),
      body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.clients.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: widget.clients[index],
                          groupValue: widget.selectedClient,
                          activeColor: kColorScheme.primary,
                          title: Text(widget.clients[index].name, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18.0,
                            color: kColorScheme.primary,
                          ),
                          ),
                          subtitle: Text("${widget.clients[index].addressName} ${widget.clients[index].addressNumber}, ${widget.clients[index].zipCode} ${widget.clients[index].city}"),
                          onChanged: (value) {
                            setState(() {
                              widget.selectedClient = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 8.0),
                    ],
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _onAddPressed,
                  child: const Text('Add'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      );
  }
}