
import 'package:flutter/material.dart';


/// indicator for the pie chart used in the statistics screen.
/// source : https://github.com/imaNNeo/fl_chart/tree/master/example
class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
    this.fontWeight,
  });

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: fontWeight,
            fontStyle: FontStyle.italic,
            color: textColor,
          ),
        )
      ],
    );
  }
}