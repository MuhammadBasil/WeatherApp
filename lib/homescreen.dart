import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String apiKey = '577583b5f9209da5e58d400d1c2176b8';
  String city = 'Karachi';
  Map<String, dynamic>? weatherData; // Initialize as null
  final TextEditingController _cityController =
      TextEditingController(); // Controller for the text input

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      setState(() {
        weatherData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'City: $city',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Temperature: ${weatherData!['main']['temp']}°C',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Description: ${weatherData!['weather'][0]['description']}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  // Text input field for entering a new city
                  TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Enter City',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Button to update the city and fetch weather data
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        city = _cityController.text;
                        _cityController.clear();
                      });
                      fetchWeather(); // Fetch weather data for the new city
                    },
                    child: const Text('Update City'),
                  ),
                ],
              ),
            ),
    );
  }
}
