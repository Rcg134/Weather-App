import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/forecastitemcard.dart';
import 'package:weather_app/informationitem.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  double temp = 0;
  String tempToString = '';
  String weather = '';
  double humidity = 0;
  double windSpeed = 0;
  double pressure = 0;
  double toCelciousKelvin = 273.15;

  bool isloading = false;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try {
      setState(() {
        isloading = true;
      });
      String cityName = 'Calamba,PH';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (int.parse(data['cod']) != 200) {
        throw 'An unexpected error occured';
      } else {
        setState(() {
          temp = data['list'][0]['main']['temp'] - toCelciousKelvin;
          weather = data['list'][0]['weather'][0]['main'];
          humidity =
              double.parse(data['list'][0]['main']['humidity'].toString());
          windSpeed = double.parse(data['list'][0]['wind']['speed'].toString());
          pressure =
              double.parse(data['list'][0]['main']['pressure'].toString());
          tempToString = temp.toStringAsFixed(2);
          isloading = false;
        });
      }
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print('Refresh');
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: isloading
          ? const CircularProgressIndicator()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //MAIN WEATHERR
                Padding(
                  padding:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 230,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Column(
                              //INSIDE MAIN WEATHER APP
                              children: [
                                Text(
                                  '$tempToString °C',
                                  style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                const Icon(
                                  Icons.cloud,
                                  size: 65,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  weather,
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 15),
                  child: Text(
                    'Weather Forecast',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 15),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForeCastItemCard(
                          time: '9.23am',
                          icon: Icons.cloud,
                          temperature: '320° F',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        HourlyForeCastItemCard(
                          time: '9.23am',
                          icon: Icons.cloud,
                          temperature: '320° F',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        HourlyForeCastItemCard(
                          time: '9.23am',
                          icon: Icons.cloud,
                          temperature: '320° F',
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        HourlyForeCastItemCard(
                          time: '9.23am',
                          icon: Icons.cloud,
                          temperature: '320° F',
                        ),
                      ],
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.only(right: 15, left: 15, bottom: 5),
                  child: Text(
                    'Additional Information',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InformationDetails(
                        icon: Icons.water_drop_sharp,
                        labelText: 'Humidity',
                        valueText: humidity,
                      ),
                      InformationDetails(
                        icon: Icons.wind_power,
                        labelText: 'Wind Speed',
                        valueText: windSpeed,
                      ),
                      InformationDetails(
                        icon: Icons.umbrella,
                        labelText: 'Pressure',
                        valueText: pressure,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
