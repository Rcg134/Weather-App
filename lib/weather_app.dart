import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:weather_app/forecastitemcard.dart';
import 'package:weather_app/informationitem.dart';
import 'package:weather_app/secrets.dart';
import 'package:intl/intl.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'Calamba,PH';
      final res = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openAPIKey',
        ),
      );
      final data = jsonDecode(res.body);
      if (int.parse(data['cod']) != 200) {
        throw 'An unexpected error occured';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
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
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Center(
                child: Text(
                  snapshot.error.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
            );
          }

          final data = snapshot.data;
          const double toCelciousKelvin = 273.15;
          final currentWeatherData = data!['list'][0];

          final temp = currentWeatherData['main']['temp'] - toCelciousKelvin;
          final weather = currentWeatherData['weather'][0]['main'];
          final humidity =
              double.parse(currentWeatherData['main']['humidity'].toString());
          final windSpeed =
              double.parse(currentWeatherData['wind']['speed'].toString());
          final pressure =
              double.parse(currentWeatherData['main']['pressure'].toString());
          final tempToString = temp.toStringAsFixed(2);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //MAIN WEATHERR
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, bottom: 15),
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
                                    fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Icon(
                                weather == 'Clouds' || weather == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
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

              Padding(
                  padding:
                      const EdgeInsets.only(right: 15, left: 15, bottom: 15),
                  child: SizedBox(
                    height: 190,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data['list'].length - 1,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky = data['list'][index + 1]['weather'][0]
                                        ['main'] ==
                                    'Clouds' ||
                                data['list'][index + 1]['weather'][0]['main'] ==
                                    'Rain'
                            ? Icons.cloud
                            : Icons.sunny;
                        final hourlyTemp = formattoString(data['list']
                                [index + 1]['main']['temp'] -
                            toCelciousKelvin);

                        return HourlyForeCastItemCard(
                          date:
                              formatDateTime(hourlyForecast['dt_txt'], 'date'),
                          time:
                              formatDateTime(hourlyForecast['dt_txt'], 'time'),
                          icon: hourlySky,
                          temperature: hourlyTemp,
                        );
                      },
                    ),
                  )),

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
          );
        },
      ),
    );
  }

  String formatDateTime(String inputDateString, String option) {
    if (option == 'time') {
      DateTime dateTime = DateTime.parse(inputDateString);
      String formattedTime = DateFormat('h:mm a').format(dateTime);
      return formattedTime;
    } else if (option == 'date') {
      DateTime dateTime = DateTime.parse(inputDateString);
      String formattedDate = DateFormat('MMM d').format(dateTime);
      return formattedDate;
    }
    return throw 'No satisfied parameter';
  }

  String formattoString(double input) {
    String formattedNumber = input.toStringAsFixed(2);

    return formattedNumber;
  }
}
