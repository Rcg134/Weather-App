import 'package:flutter/material.dart';

class BottomSearch extends StatefulWidget {
  final void Function(String) updateWeatherCallback;

  const BottomSearch({Key? key, required this.updateWeatherCallback})
      : super(key: key);
  @override
  State<BottomSearch> createState() => _BottomSearchState();
}

class _BottomSearchState extends State<BottomSearch> {
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 71, 71, 71),
              Color.fromARGB(255, 64, 59, 59),
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.5,
        width: double.infinity,
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 300,
              child: TextField(
                style: const TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                ),
                decoration: InputDecoration(
                  hintText: 'Search Cities (City,Country)',
                  hintStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                onSubmitted: (String value) {
                  // Call the getCurrentWeather function with the entered value
                  widget.updateWeatherCallback(value);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
