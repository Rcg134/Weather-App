import 'package:flutter/material.dart';

class HourlyForeCastItemCard extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForeCastItemCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 180,
      height: 162,
      child: Card(
        color: Color.fromARGB(255, 84, 118, 212),
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Column(
            children: [
              Text(
                '09:00',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.cloud,
                size: 35,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '320° F',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
