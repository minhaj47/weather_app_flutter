import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:conversion_units/conversion_units.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_flutter_app/additional_item_card.dart';
import 'package:weather_flutter_app/hourly_forcast_item.dart';
import 'package:weather_flutter_app/secret.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    log('inside getWeather');

    String cityName = 'Kishoreganj';
    final res = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
    );
    final data = jsonDecode(res.body);
    if (data['cod'] != '200') {
      throw Exception(data['message']);
    }
    log('got data');
    return data;
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    log('inside build fn');
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
            onPressed: () => setState(() {
              weather = getCurrentWeather();
            }),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          log('inside future builder');
          log(snapshot.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            log(snapshot.error.toString());
            return Center(child: Text(snapshot.error.toString()));
          }

          // retreiving the data
          final data = snapshot.data!;
          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];
          final currentPressure = currentWeatherData['main']['pressure'];
          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // main card
                SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(19.0),
                          child: Column(
                            children: [
                              Text(
                                '${Kelvin.toCelsius(currentTemp).toStringAsFixed(2)}° C',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 13),
                              Icon(
                                currentSky == 'Clouds' || currentSky == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 80,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // forcasrt card

                const Text(
                  'Hourly Forcast',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      final hourlyForcast = data['list'][index + 1];
                      final hourlyTemparature = hourlyForcast['main']['temp'];
                      final hourlySky = hourlyForcast['weather'][0]['main'];
                      final dateTime =
                          DateTime.parse(hourlyForcast['dt_txt'].toString());
                      return HourlyForcastCard(
                        temparature: hourlyTemparature,
                        time: DateFormat.j().format(dateTime).toString(),
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AdditionalInfoCard(
                        icon: Icons.water_drop,
                        propertyName: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoCard(
                        icon: Icons.air,
                        propertyName: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoCard(
                        icon: Icons.beach_access,
                        propertyName: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
