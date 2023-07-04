
import 'package:flutter/material.dart';

import '../../models/client.dart';


class CreateClientScreen extends StatefulWidget {

  const CreateClientScreen({super.key});

  @override
  State<CreateClientScreen> createState() => _CreateClientScreenState();
}

class _CreateClientScreenState extends State<CreateClientScreen> {

  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _name = '';
  String _addressName = '';
  int _addressNumber = 0;
  int _zipCode = 0;
  String _city = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Input'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        //child: ListView(
          child: //[
            Form(
              key: _formKey,
              child: ListView(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _name = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _addressName = value!;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Address Number'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an address number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _addressNumber = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'ZIP Code'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a ZIP code';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _zipCode = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'City'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a city';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _city = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Save'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        // Create a new client object with the input data
                        Client newClient = Client(
                          _id,
                          _name,
                          _addressName,
                          _addressNumber,
                          _zipCode,
                          _city,
                        );

                        // Do something with the new client object (e.g., save to database)
                        print('New client: $newClient');
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