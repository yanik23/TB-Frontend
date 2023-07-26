
import 'package:flutter/material.dart';
import '../data/database.dart';
import 'loginScreen.dart';

// The color scheme of the application
var kColorScheme = const ColorScheme(
  primary: Color.fromARGB(255, 238, 128, 87),
  secondary: Color.fromARGB(255, 162, 99, 3),
  surface: Colors.white,
  background: Colors.white,
  error: Colors.red,
  onPrimary: Colors.white,
  onSecondary: Colors.white,
  onSurface: Colors.black,
  onBackground: Colors.black,
  onError: Colors.white,
  brightness: Brightness.light,
);

/// This class is used to display the welcome screen of the application.
///
/// @author Yanik Lange
/// @date 26.07.2023
/// @version 1
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  /// This function is used to navigate to the login screen.
  void _login() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LoginScreen(),
      ),
    );
  }

  /// This function is used to initialize the local database.
  Future<void> initializeDatabase() async {
    await DBHelper.initializeDatabase();
  }

  /// This function is used to initialize the state of the welcome screen.
  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  /// This function is used to build the welcome screen.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorScheme.primary,
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/bokafood-logo.png', width: 200),
          ),
          const Text('Welcome to the Bokafood app',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontSize: 18)),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: _login,
            icon: const Icon(Icons.play_arrow, color: Colors.white),
            label: const Text('Start', style: TextStyle(color: Colors.white)),
          ),
        ]),
      ),
    );
  }
}
