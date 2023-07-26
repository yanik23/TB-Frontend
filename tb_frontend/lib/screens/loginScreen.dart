import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';
import '../utils/secureStorageManager.dart';
import '../models/user.dart';
import 'menuScreen.dart';

/// This class is used to display the login screen of the application.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// This class is used to manage the state of the login screen.
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  // the username and password controller used to get the user input
  final _usernameController = TextEditingController(text: "");
  final _passwordController = TextEditingController(text: "");

  // the password input is hidden by default
  bool _isPasswordInputHidden = true;

  /// This function is used to login the user. if the login is successful the user is navigated to the menu screen.
  void _menuScreen(String username) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MenuScreen(username),
      ),
    );
  }

  /// This function is used to login the user.
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
                  if (value == null || value.isEmpty) {
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
                    // add the visibility toggle icon
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
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    // show a snackbar to indicate that the login is in progress
                    const snackBar = SnackBar(
                      content: Text('trying to login...',
                          textAlign: TextAlign.center),
                      showCloseIcon: true,
                      closeIconColor: Colors.white,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    // login the user
                    final Future<(String, String)> futureTokens = login(
                        _usernameController.text, _passwordController.text);
                    // if the login is successful store the username and password in the secure storage
                    futureTokens.then((token) {
                      SecureStorageManager.write(
                          "KEY_USERNAME", _usernameController.text);
                      SecureStorageManager.write(
                          "KEY_PASSWORD", _passwordController.text);
                      SecureStorageManager.write("ACCESS_TOKEN", token.$1);
                      SecureStorageManager.write("REFRESH_TOKEN", token.$2);

                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      _menuScreen(_usernameController.text.toString());
                      // if the login is not successful show an error message
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      final snackBar = SnackBar(
                        content: Text(e.message.toString(),
                            textAlign: TextAlign.center),
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
              // the forgot password button
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
