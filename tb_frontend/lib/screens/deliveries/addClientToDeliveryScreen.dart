



import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../models/dish.dart';
import '../welcomeScreen.dart';
import '../../utils/widgets/searchBar.dart' as sb;


/*class DishCheck {
  String name = "";
  bool check = false;
  DishCheck({this.check = false});
}*/
class AddClientToDeliveryScreen extends StatefulWidget {

  List<Client> clients;
  String? selectedClient;

  AddClientToDeliveryScreen(this.clients, this.selectedClient, {super.key});

  @override
  State<AddClientToDeliveryScreen> createState() => _AddClientToDeliveryScreenState();

}


class _AddClientToDeliveryScreenState extends State<AddClientToDeliveryScreen> {
  List<Client> searchedClients = [];
  //Dish dish = Dish();
  bool _showSearchBar = false;
  TextEditingController editingController = TextEditingController();


  @override
  void initState() {
    super.initState();
    searchedClients = widget.clients;
  }

  void _onAddPressed() {
    Navigator.of(context).pop(widget.selectedClient);
  }

  void _filterSearchResults(String query) {
    setState(() {
      searchedClients = widget.clients
          .where((client) =>
          client.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
            if (_showSearchBar) sb.SearchBar(editingController, _filterSearchResults),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: searchedClients.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          value: searchedClients[index].name,
                          groupValue: widget.selectedClient,
                          activeColor: kColorScheme.primary,
                          title: Text(searchedClients[index].name, style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18.0,
                            color: kColorScheme.primary,
                          ),
                          ),
                          subtitle: Text("${searchedClients[index].addressName} ${searchedClients[index].addressNumber}, ${searchedClients[index].zipCode} ${searchedClients[index].city}"),
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