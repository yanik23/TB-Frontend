import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/statistic.dart';
import 'indicator.dart';

class StatisticsTotalScreen extends StatefulWidget {
  const StatisticsTotalScreen({super.key});

  @override
  State<StatisticsTotalScreen> createState() => _StatisticsTotalScreenState();
}

Color getColorByIndex(int index) {
  const List<Color> colors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.blue,
    Colors.purple,
    Colors.orange,
  ];
  return colors[index % colors.length];
}

class _StatisticsTotalScreenState extends State<StatisticsTotalScreen> {
  int touchedIndex = -1;
  bool showDeliveredPerType = true;

  late Future<List<AvgDeliveredPerType>> avgDeliveriesPerType;
  List<AvgDeliveredPerType> localAvgDeliveredPerType = [];
  late Future<List<QuantityDeliveredPerSize>> quantityDeliveredPerSize;
  List<QuantityDeliveredPerSize> localQuantityDeliveredPerSize = [];

  @override
  void initState() {
    // TODO: implement initState
    log("initState");
    avgDeliveriesPerType = fetchTotalDeliveriesPerType();
    avgDeliveriesPerType.then((value) => {
          setState(() {
            localAvgDeliveredPerType.addAll(value);
          }),
        });

    quantityDeliveredPerSize = fetchQuantitiesDeliveredPerSize();
    quantityDeliveredPerSize.then((value) => {
          setState(() {
            localQuantityDeliveredPerSize.addAll(value);
          }),
        });
    super.initState();
  }

  void _toggleContent() {
    log("=============toggleContent");
    setState(() {
      showDeliveredPerType = !showDeliveredPerType;
    });
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Average Delivered Per Type'),
                leading: Radio(
                  value: true,
                  groupValue: showDeliveredPerType,
                  onChanged: (value) {
                    setState(() {
                      showDeliveredPerType = value as bool;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text('Quantity Delivered Per Size'),
                leading: Radio(
                  value: false,
                  groupValue: showDeliveredPerType,
                  onChanged: (value) {
                    setState(() {
                      showDeliveredPerType = value as bool;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {
              //_toggleContent();
              showFilterDialog();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<AvgDeliveredPerType>>(
        future: avgDeliveriesPerType,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<dynamic> content = showDeliveredPerType
                ? localAvgDeliveredPerType
                : localQuantityDeliveredPerSize;
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 0,
                        centerSpaceRadius: 50,
                        sections: showingSections(content),
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      for (int i = 0; i < content.length; i++)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 4),
                          child: Indicator(
                            color: getColorByIndex(i),
                            text: showDeliveredPerType
                                ? '${content[i].currentType}'
                                : '${content[i].currentSize}',
                            isSquare: false,
                            textColor: getColorByIndex(i),
                            fontWeight: i == touchedIndex
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      const SizedBox(height: 8)
                    ],
                  ),
                ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  List<PieChartSectionData> showingSections(List<dynamic> content) {
    return List.generate(content.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: getColorByIndex(i),
            value: 40,
            title: showDeliveredPerType
                ? '${content[i].avgDelivered}'
                : '${content[i].quantityDelivered}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: getColorByIndex(i + 1),
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: getColorByIndex(i),
            value: 30,
            title: showDeliveredPerType
                ? '${content[i].avgDelivered}'
                : '${content[i].quantityDelivered}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: getColorByIndex(i + 1),
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: getColorByIndex(i),
            value: 15,
            title: showDeliveredPerType
                ? '${content[i].avgDelivered}'
                : '${content[i].quantityDelivered}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: getColorByIndex(i + 1),
              shadows: shadows,
            ),
          );
        default:
          {
            log('Error: Invalid index');
            throw Error();
          }
      }
    });
  }
}
