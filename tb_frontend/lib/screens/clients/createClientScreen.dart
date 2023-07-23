import 'dart:developer';

import 'package:flutter/material.dart';

import '../../models/client.dart';
import '../../utils/constants.dart';

class CreateClientScreen extends StatefulWidget {
  final Client? client;
  final String title;
  const CreateClientScreen(this.title, {this.client, super.key});

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


  final RegExp _nameRegExp = RegExp(nameRegexPattern);
  final RegExp _streetAndCityRegExp = RegExp(streetAndCityRegexPattern);
  final RegExp _intRegExp = RegExp(intRegexPattern);
  final RegExp _doubleRegExp = RegExp(doubleRegexPattern);

  @override
  void initState() {
    if (widget.client != null) {
      super.initState();
      setState(() {
        _id = widget.client!.id;
        _name = widget.client!.name;
        _addressName = widget.client!.addressName;
        _addressNumber = widget.client!.addressNumber;
        _zipCode = widget.client!.zipCode;
        _city = widget.client!.city;
      });
    }
  }


  void _createOrUpdateClient() {
    // Create a new client object with the input data
    Client newClient = Client(
      _id,
      _name,
      _addressName,
      _addressNumber,
      _zipCode,
      _city,
    );
    Future<Client> resultClient;
    String snackBarMessage = '';
    if(widget.client == null) {
      resultClient = createClient(newClient);
      snackBarMessage = 'Client created successfully';
    } else {
      resultClient = updateClient(newClient);
      snackBarMessage = 'Client updated successfully';
    }
    resultClient.then((client) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(snackBarMessage, textAlign: TextAlign.center),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      Navigator.of(context).pop(client);
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

    // Go back to the previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter the client name',
                ),
                initialValue: _name,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty || !_nameRegExp.hasMatch(value)) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address Name',
                    hintText: 'Enter the address name'),
                initialValue: _addressName,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty || !_streetAndCityRegExp.hasMatch(value)) {
                    return 'Please enter a valid address name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addressName = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address Number',
                    hintText: 'Enter the address number'),
                initialValue: _addressNumber == 0 ? '' : _addressNumber.toString(),
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty || !_intRegExp.hasMatch(value)) {
                    return 'Please enter a valid address number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addressNumber = int.parse(value!);
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ZIP Code',
                    hintText: 'Enter the ZIP code'),
                initialValue: _zipCode == 0 ? '' : _zipCode.toString(),
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty || !_intRegExp.hasMatch(value)) {
                    return 'Please enter a valid ZIP code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _zipCode = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'City',
                    hintText: 'Enter the city'),
                initialValue: _city,
                maxLength: 50,
                validator: (value) {
                  if (value == null || value.isEmpty || !_streetAndCityRegExp.hasMatch(value)) {
                    return 'Please enter a valid city';
                  }
                  return null;
                },
                onSaved: (value) {
                  _city = value!;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _createOrUpdateClient();
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
