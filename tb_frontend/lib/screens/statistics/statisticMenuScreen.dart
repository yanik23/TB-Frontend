


import 'package:flutter/material.dart';
import 'package:tb_frontend/screens/statistics/monthlyStatisticsScreen.dart';
import 'package:tb_frontend/screens/statistics/statisticsTotalScreen.dart';

class StatisticMenuScreen extends StatelessWidget {
  const StatisticMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistic Menu'),
      ),
      body: GridView(
        padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        children: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) {
                    return const StatisticsTotalScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.pie_chart, size: 36),
            label: const Text('Total / Average'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
          ),
          TextButton.icon(
            onPressed: () {

            },
            icon: const Icon(Icons.monetization_on, size: 36),
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
                    return const MonthlyStatisticsScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.timeline, size: 36),
            label: const Text('Total/Average overt time'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
          ),


        ],
      ),
      );
  }
}