
import 'package:flutter/material.dart';
import '../data/database.dart';
import 'loginScreen.dart';

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

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  void _login() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const LoginScreen(),
      ),
    );
  }

  Future<void> initializeDatabase() async {
    await DBHelper.initializeDatabase();
    // Additional initialization logic, if needed
  }

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

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
          //Image.asset('assets/images/bokafood-logo.png', width: 200,
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
