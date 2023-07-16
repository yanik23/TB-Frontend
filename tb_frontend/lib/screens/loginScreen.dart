import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/SecureStorageManager.dart';

import '../models/user.dart';
import 'menuScreen.dart';

import 'package:dargon2_flutter/dargon2_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //final _secureStorage = const FlutterSecureStorage();

  late String token;

  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");
  bool _isPasswordInputHidden = true;
  final bool _savePassword = true;

  bool isAvailable = true;

  void _menuScreen(String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MenuScreen(username),
      ),
    );
  }

  Future<bool> _localLogin(String username, String password) async {
    final storage = FlutterSecureStorage();
    String? usernametmp = await storage.read(key: "KEY_USERNAME");
    String? passwordtmp = await storage.read(key: "KEY_PASSWORD");

    SecureStorageManager.read("KEY_PASSWORD")
        .then((value) => passwordtmp = value);
    return (_usernameController.text == usernametmp &&
        _passwordController.text == passwordtmp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 48),
          /*alignment: Alignment.center,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,*/
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
                  if (value == null ||
                      value.isEmpty /*|| !emailRegex.hasMatch(value)*/) {
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
                        icon: Icon(_isPasswordInputHidden
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _isPasswordInputHidden = !_isPasswordInputHidden;
                          });
                        })),
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Please enter a valid password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    const snackBar = SnackBar(
                      content: Text('trying to login...'),
                      duration: Duration(seconds: 4),
                      /*action: SnackBarAction(
                        label: 'UNDO',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),*/
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    try {
                      final Future<String> futureToken = login(
                          _usernameController.text, _passwordController.text);

                      if (futureToken != null) {
                        futureToken.then((token) {
                          log('bla===== $futureToken');
                          SecureStorageManager.write(
                              "KEY_USERNAME", _usernameController.text);
                          SecureStorageManager.write(
                              "KEY_PASSWORD", _passwordController.text);
                          SecureStorageManager.write("KEY_TOKEN", token);

                          log(token);
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          _menuScreen(_usernameController.text.toString());
                        }).catchError((e) {
                          final snackBar = SnackBar(
                            content: Text(e.message.toString()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          log(e.toString());
                          const snackBar3 = SnackBar(
                            content: Text('failed to login'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar3);
                          log(e.toString());

                          const snackBar2 = SnackBar(
                            content: Text('login in with local data...'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);
                          log(e.toString());

                          _localLogin(_usernameController.text,
                                  _passwordController.text)
                              .then((value) {
                            if (value) {
                              ScaffoldMessenger.of(context)
                                  .removeCurrentSnackBar();
                              _menuScreen(_usernameController.text.toString());
                            } else {
                              const snackBar3 = SnackBar(
                                content: Text('failed to login'),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar3);
                              log(e.toString());
                            }
                          });
                        });
                      } else {
                        log('Token is null');
                      }
                    } catch (e) {

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
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 12),
              TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Forgot your username or password ?'),
                        content: const Text(
                            'Please contact the BokaFood administrator.'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text('OK')),
                        ],
                      ),
                    );
                  },
                  child: const Text('Forgot username or password ?')),
            ],
          ),
        ),
      ),
    );
  }
}
