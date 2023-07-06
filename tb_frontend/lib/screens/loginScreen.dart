
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/SecureStorageManager.dart';

import '../models/user.dart';
import 'menuScreen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //final _secureStorage = const FlutterSecureStorage();

  late String token;
  
  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  bool _isPasswordInputHidden = true;
  final bool _savePassword = true;

  // Read values
  Future<void> _readFromStorage() async {
    //_usernameController.text = await _storage.read(key: "KEY_USERNAME") ?? '';
    //_passwordController.text = await _storage.read(key: "KEY_PASSWORD") ?? '';
  }

  void _onFormSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_savePassword) {
        // Write values
        //await _storage.write(key: "KEY_USERNAME", value: _usernameController.text);
        //await _storage.write(key: "KEY_PASSWORD", value: _passwordController.text);
      }
    }
  }

  bool isAvailable = true;

  void _menuScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) =>
            const MenuScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                'Welcome !',
                style: TextStyle(
                  fontSize: 32,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: kColorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _usernameController,
                maxLength: 50,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  icon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty /*|| !emailRegex.hasMatch(value)*/) {
                    return 'Please enter a valid username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                maxLength: 50,
                obscureText: _isPasswordInputHidden,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  icon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordInputHidden ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordInputHidden = !_isPasswordInputHidden;
                      });
                    }
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: const Text('Is Available'),
                value: isAvailable,
                onChanged: (value) {
                  setState(() {
                    isAvailable = value;
                  });
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    log("=============== validate ===============");

                    final Future<String> futureToken = login(
                        _usernameController.text, _passwordController.text);

                    if (futureToken != null) {
                      futureToken.then((token) {
                        if (token != null) {
                          log("================ storing in secure storage ================");
                          SecureStorageManager.write("KEY_USERNAME", _usernameController.text);
                          SecureStorageManager.write("KEY_PASSWORD", _passwordController.text);
                          SecureStorageManager.write("KEY_TOKEN", token);

                          log(token);
                          _menuScreen();
                        }
                      });
                    }
                    else {
                      log('Token is null');
                    }
                    /*FutureBuilder<String>(
                    future: _futureToken,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }

                      return const CircularProgressIndicator();
                    },
                  );*/
                  }
                },
                child: const Text('Sign in'),
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: () {
                showDialog(context: context, builder: (ctx) => AlertDialog(
                  title: const Text('Forgot your username or password ?'),
                  content: const Text('Please contact the BokaFood administrator.'),
                  actions: [
                    TextButton(onPressed: () {
                      Navigator.of(ctx).pop();
                    }, child: const Text('OK')),
                  ],
                ),
                );
              }, child: const Text('Forgot username or password ?')),
            ],
          ),
        ),
      ),
    );
  }
}