import 'package:flutter/material.dart';

class HourlyForeCastItemCard extends StatelessWidget {
  final String date;
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForeCastItemCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.temperature,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 180,
        height: 190,
        child: Card(
          color: const Color.fromARGB(255, 84, 118, 212),
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  time,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                Icon(
                  icon,
                  size: 35,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '$temperature° C',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
