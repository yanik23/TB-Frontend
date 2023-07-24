

import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../utils/secureStorageManager.dart';
import '../models/user.dart';
import 'menuScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();


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
                maxLength: 20,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  icon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
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
                      content: Text('trying to login...', textAlign: TextAlign.center),
                      showCloseIcon: true,
                      closeIconColor: Colors.white,

                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      final Future<(String, String)> futureTokens = login(
                          _usernameController.text, _passwordController.text);

                      //if (futureTokens != null) {
                        futureTokens.then((token) {
                          SecureStorageManager.write(
                              "KEY_USERNAME", _usernameController.text);
                          SecureStorageManager.write(
                              "KEY_PASSWORD", _passwordController.text);
                          SecureStorageManager.write("ACCESS_TOKEN", token.$1);
                          SecureStorageManager.write("REFRESH_TOKEN", token.$2);

                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          _menuScreen(_usernameController.text.toString());
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).removeCurrentSnackBar();
                          final snackBar = SnackBar(
                            content: Text(e.message.toString(), textAlign: TextAlign.center),
                            backgroundColor: Colors.red,
                            showCloseIcon: true,
                            closeIconColor: Colors.white,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        });
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
