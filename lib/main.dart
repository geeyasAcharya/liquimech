// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:liquimech/add_device.dart';
// import 'package:liquimech/access_token.dart';
import 'package:liquimech/homepage.dart';

import 'package:http/http.dart' as http;

//gloabl variables
String accessToken = '';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: true,
    );
  }
}

Future<http.Response?> getToken() async {
  print('getting token');
  var url = Uri.parse('https://api2.arduino.cc/iot/v1/clients/token');
  var response = await http.post(
    url,
    headers: {'content-type': 'application/x-www-form-urlencoded'},
    body: {
      'grant_type': 'client_credentials',
      'client_id': 'rx0ph5orF5cdSfxKuAofB6fJtQAG1j9x', // Geeyas's client id
      'client_secret':
          'it8b8tyEVU3ANB3xq4nFrO2Py6uQSDSVJfRgR5Sj3LDRxZrf0Mwbu6xM3cy4pa46', // Geeyas's client credentials
      'audience': 'https://api2.arduino.cc/iot'
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        accessToken = responseData['access_token'];
        return accessToken;
      } else {
        print('Error');
      }
    },
  );
  print('token printed');
}
