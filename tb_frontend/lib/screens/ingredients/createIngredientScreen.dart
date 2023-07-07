import 'package:flutter/material.dart';

import '../../models/ingredient.dart';





class CreateIngredientScreen extends StatefulWidget {
  final Ingredient? ingredient;
  const CreateIngredientScreen({this.ingredient, super.key});

  @override
  State<CreateIngredientScreen> createState() => _CreateIngredientScreenState();
}

class _CreateIngredientScreenState extends State<CreateIngredientScreen> {
  final _formKey = GlobalKey<FormState>();

  int _id = 0;
  String _name = '';
  String _currentType = '';
  String? _description;
  String? _supplier = '';

  @override
  void initState() {
    if (widget.ingredient != null) {
      super.initState();
      setState(() {
        _id = widget.ingredient!.id;
        _name = widget.ingredient!.name;
        _description = widget.ingredient!.description;
        _currentType = widget.ingredient!.type;
        _supplier = widget.ingredient!.supplier;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Ingredient'),
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
                  hintText: 'Enter the ingredient name',
                ),
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),

              DropdownButtonFormField(
                decoration: const InputDecoration(
                    labelText: 'Type',
                    hintText: 'Select the type of ingredient'),
                onChanged: (value) {
                  setState(() {
                    _currentType = value.toString().toUpperCase();
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
                  hintText: 'Enter the description',
                ),
                initialValue: _description,
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Supplier (Optional)',
                  hintText: 'Enter the supplier',
                ),
                initialValue: _supplier,
                onSaved: (value) {
                  _supplier = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }

                  Ingredient newIngredient = Ingredient(
                    _id,
                    _name,
                    _currentType,
                    description: _description,
                    supplier: _supplier,
                  );

                  Future<Ingredient> resultIngredient;
                  if (widget.ingredient == null) {
                    resultIngredient = createIngredient(newIngredient);
                  } else {
                    resultIngredient = updateIngredient(newIngredient);
                  }
                  resultIngredient.whenComplete(() => Navigator.of(context).pop(resultIngredient));

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
