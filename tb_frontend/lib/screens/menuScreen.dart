import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/deliveries/deliveriesScreen.dart';
import 'package:tb_frontend/screens/ingredients/ingredientsScreen.dart';
import 'package:tb_frontend/screens/scanner/qrScannerScreen.dart';
import 'package:tb_frontend/screens/statistics/statisticMenuScreen.dart';
import 'package:tb_frontend/screens/welcomeScreen.dart';
import 'clients/clientsScreen.dart';
import 'dishes/dishesScreen.dart';

class MenuScreen extends StatefulWidget {

  final String username;
  const MenuScreen(this.username, {super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: kColorScheme.primary,
                ),
                child: Text(
                  'Welcome ${widget.username} !',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      return const WelcomeScreen();
                    }),
                  );
                },
              ),
            ],
          )
        ),
        body: GridView(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const DishesScreen('Dishes');
                    },
                  ),
                );
              },
              icon: const Icon(Icons.local_dining_sharp, size: 36),
              label: const Text('Dishes'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const IngredientsScreen();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.fastfood, size: 36),
              label: const Text('Ingredients'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const ClientsScreen();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.person, size: 36),
              label: const Text('Clients'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const DeliveriesScreen();
                  }),
                );
              },
              icon: const Icon(Icons.delivery_dining, size: 36),
              label: const Text('Deliveries'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const StatisticMenuScreen();
                  }),
                );
              },
              //child: const Text('Stats'),
              icon: const Icon(Icons.stacked_bar_chart, size: 36),
              label: const Text('Stats'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
                  return const QrScannerScreen();
                }),
                );
              },
              icon: const Icon(Icons.photo_camera_rounded, size: 36),
              label: const Text('QR Scanner'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.stacked_bar_chart), label: 'Stats'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_dining_sharp), label: 'Dishes'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Clients'),
            BottomNavigationBarItem(
                icon: Icon(Icons.fastfood), label: 'Ingredients'),
            BottomNavigationBarItem(
                icon: Icon(Icons.delivery_dining), label: 'Deliveries'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
          ],
        ));
  }
}
