import 'package:flutter/material.dart';

class InformationDetails extends StatelessWidget {
  final IconData icon;
  final String labelText;
  final double valueText;

  const InformationDetails({
    Key? key,
    required this.icon,
    required this.labelText,
    required this.valueText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 125,
      height: 200,
      child: Column(
        children: [
          Icon(
            icon,
            size: 45,
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            labelText,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            valueText.toString(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
