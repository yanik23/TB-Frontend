import 'package:flutter/material.dart';

import '../../models/ingredient.dart';
import '../../utils/constants.dart';

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

  final RegExp _nameRegExp = RegExp(nameRegexPattern);
  final RegExp _descriptionRegExp = RegExp(descriptionRegexPattern);

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

  void _createOrUpdateIngredient() {
    Ingredient newIngredient = Ingredient(
      _id,
      _name,
      _currentType,
      description: _description,
      supplier: _supplier,
    );

    Future<Ingredient> resultIngredient;
    String snackBarMessage = '';
    if (widget.ingredient == null) {
      resultIngredient = createIngredient(newIngredient);
      snackBarMessage = 'Ingredient created successfully';
    } else {
      resultIngredient = updateIngredient(newIngredient);
      snackBarMessage = 'Ingredient updated successfully';
    }
    resultIngredient.then((ingredient) {

     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackBarMessage),
          backgroundColor: Colors.green,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
      Navigator.of(context).pop(ingredient);

    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
          showCloseIcon: true,
          closeIconColor: Colors.white,
        ),
      );
    });
    //if no error then show snackbar with success message
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
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter the ingredient name',
                ),
                initialValue: _name,
                maxLength: 50,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().isEmpty ||
                      !_nameRegExp.hasMatch(value)) {
                    return 'Please enter a valid name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                    labelText: 'Type',
                    hintText: 'Select the type of ingredient'),
                value: _currentType == '' ? null : _currentType,
                onChanged: (value) {
                  setState(() {
                    _currentType = value.toString().toUpperCase();
                  });
                },
                items: IngredientType.values
                    .map(
                      (type) => DropdownMenuItem(
                        value: type.toString() == _currentType
                            ? _currentType
                            : type.name.toString().toUpperCase(),
                        child: Text(type.name.toString().toUpperCase()),
                      ),
                    )
                    .toList(),
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
                maxLength: 255,
                validator: (value) {
                  if (!_descriptionRegExp.hasMatch(value!)) {
                    return 'Please enter a valid description';
                  }
                  return null;
                },
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
                maxLength: 50,
                validator: (value) {
                  if (!_nameRegExp.hasMatch(value!)) {
                    return 'Please enter a valid supplier';
                  }
                  return null;
                },
                onSaved: (value) {
                  _supplier = value!;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _createOrUpdateIngredient();
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
