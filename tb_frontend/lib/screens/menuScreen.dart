import 'package:flutter/material.dart';
import 'package:tb_frontend/data/dummyDishes.dart';
import 'package:tb_frontend/screens/ingredients/ingredientsScreen.dart';
import 'clients/clientsScreen.dart';
import 'dishes/dishesScreen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
        drawer: const Drawer(),
        body: GridView(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return DishesScreen('Dishes');
                    },
                  ),
                );
              },
              child: const Text('Dishes'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return IngredientsScreen();
                    },
                  ),
                );
              },
              child: const Text('Ingredients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return ClientsScreen();
                    },
                  ),
                );
              },
              child: const Text('Clients'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: const Text('Deliveries'),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: 'Stats'),
            BottomNavigationBarItem(icon: Icon(Icons.local_dining_sharp), label: 'Dishes'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Clients'),
            BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Ingredients'),
            BottomNavigationBarItem(icon: Icon(Icons.delivery_dining), label: 'Deliveries'),
            BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),

          ],
        ));
  }
}
