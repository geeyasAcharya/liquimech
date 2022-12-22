// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';

// for making http requests
import 'package:http/http.dart' as http;
import 'package:liquimech/main.dart';

//global varibale
var devi = '';
var devicesName = [];

//Class
class AccessToken extends StatefulWidget {
  final String name;
  final String id;
  final String fqbn;
  final String serial;
  final String conType;

  const AccessToken({
    super.key,
    required this.name,
    required this.id,
    required this.fqbn,
    required this.serial,
    required this.conType,
  });

  @override
  State<AccessToken> createState() => _AccessTokenState();
}

class _AccessTokenState extends State<AccessToken> {
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: const [],
        ),
      ),
    );
  }
}

Future<http.Response?> getDevices() async {
  await getToken();
  var url = Uri.parse('https://api2.arduino.cc/iot/v2/devices/');
  var response = await http.get(
    url,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json'
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        // Iterating data to get it's each element
        for (var element in data) {
          Map obj = element;
          String name = obj['name'];
          String serial = obj['serial'];
          String id = obj['id'];
          String fqbn = obj['fqbn'];
          String connectionType = obj['connection_type'];

          devi =
              "ID: $id, name: $name, serial: $serial, fqbn: $fqbn, connection_type: $connectionType";

          devicesName.add(devi);
        }
      } else {
        throw Exception('Failed to load Devices');
      }
    },
  );
}
