import 'package:flutter/material.dart';

import '../../models/ingredient.dart';





class CreateIngredientScreen extends StatefulWidget {
  const CreateIngredientScreen({Key? key}) : super(key: key);

  @override
  State<CreateIngredientScreen> createState() => _CreateIngredientScreenState();
}

class _CreateIngredientScreenState extends State<CreateIngredientScreen> {
  final _formKey = GlobalKey<FormState>();

  int id = 0;
  String name = '';
  String? description;
  String currentType = '';
  String supplier = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ingredient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  //hintText: 'Enter the name of the dish',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  name = value!;
                },
              ),

              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                //value: _selectedDishSize,
                onChanged: (value) {
                  setState(() {
                    currentType = value.toString().toUpperCase();
                  });
                },
                items: IngredientType.values
                    .map(
                      (type) => DropdownMenuItem(
                    value: type,
                    child: Text(type.name.toString().toUpperCase()),
                  ),
                ).toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select a valid Type';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description (Optional)',
                  //hintText: 'Enter the name of the dish',
                ),
                /*validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },*/
                onSaved: (value) {
                  description = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Supplier (Optional)',
                  //hintText: 'Enter the name of the dish',
                ),
                /*validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a supplier';
                  }
                  return null;
                },*/
                onSaved: (value) {
                  supplier = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
