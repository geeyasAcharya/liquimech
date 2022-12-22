import 'dart:convert';

import 'package:flutter/material.dart';

//for http
import 'package:http/http.dart' as http;

//global variables
String accessToken = '';

// text controller and dropDown Menu variables
String? selDeviceType = '';
final nameController = TextEditingController();
final fqbnController = TextEditingController();
final serialController = TextEditingController();

class AddDevice extends StatefulWidget {
  const AddDevice({super.key});

  @override
  State<AddDevice> createState() => _AddDeviceState();
}

class _AddDeviceState extends State<AddDevice> {
  //assignning value to dropdown menu
  _AddDeviceState() {
    selDeviceType = deviceType[0];
  }

// variables
  var deviceType = [
    "mkrwifi1010",
    "mkr1000",
    "nano_33_iot",
    "mkrgsm1400",
    "mkrwan1310",
    "mkrwan1300",
    "mkrnb1500",
    "lora-device",
    "login_and_secretkey_wifi",
    "envie_m7",
    "nanorp2040connect",
    "nicla_vision "
  ];

  // @override
  // void dispose() {
  //   nameController.dispose();
  //   fqbnController.dispose();
  //   serialController.dispose();
  //   super.dispose();
  // }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device to Arduino Cloud'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Device Name Text Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Device Name',
                  ),
                ),
              ),
            ),
            //
            const SizedBox(
              height: 16,
            ),
            //FQBN Text Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: fqbnController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'FQBN ',
                  ),
                ),
              ),
            ),
            //
            const SizedBox(
              height: 16,
            ),
            //
            // Serial TextField
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12)),
                child: TextField(
                  controller: serialController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Device Serial',
                  ),
                ),
              ),
            ),
            //
            const SizedBox(
              height: 16,
            ),
            //
            // Serial Device type
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 48.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  child: DropdownButton(
                    value: selDeviceType,
                    items: deviceType
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selDeviceType = value;
                      });
                    },
                  )),
            ),
            //
            const SizedBox(
              height: 20,
            ),
            //
            //button to create device
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(
                      color: const Color.fromARGB(255, 201, 216, 223)),
                  borderRadius: BorderRadius.circular(10),
                  backgroundBlendMode: BlendMode.colorBurn,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 183, 203, 212),
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    )
                  ]),
              child: MaterialButton(
                onPressed: () {
                  getToken();
                  // createDevice(a);
                },
                child: const Text('Create Device'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// function to get access token using Geeyas's client id and credentials
Future<http.Response?> getToken() async {
  var url = Uri.parse('https://api2.arduino.cc/iot/v1/clients/token');
  var response = await http.post(
    url,
    headers: {'content-type': 'application/x-www-form-urlencoded'},
    body: {
      'grant_type': 'client_credentials',
      'client_id': '11BPBTVoGudlcJ8408X6HpTLYXGyEuJ1', // Geeyas's client id
      'client_secret':
          'XJJ1N3B1BpggeI5qSpF3K3t6kYSa482Ry2lNe7ofcA0o71hTpIqgh1Nn883IHnIs', // Geeyas's client credentials
      'audience': 'https://api2.arduino.cc/iot'
    },
  ).then(
    (response) {
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        accessToken = responseData['access_token'];
        // print(accessToken);
        return accessToken;
      } else {
        print('Error');
      }
    },
  );
}

Future<http.Response?> createDevice({
  required String fqbn,
  required String name,
  required String serial,
  required String deviceType,
}) async {
  var params = {
    'fqbn': fqbn,
    'name': name,
    'serial': serial,
    'type': deviceType
  };
  var url = Uri.parse('https://api2.arduino.cc/iot/v2/devices/');
  var response = await http
      .put(url,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            "fqbn": fqbnController.text.trim(),
            "name": nameController.text.trim(),
            "serial": serialController.text.trim(),
            "type": selDeviceType,

            /* 
              fqbn: "esp8266:esp8266:generic",
              name: "Geeyas_Device",
              serial: "2468642",
              type: "nano_33_iot",
            */
          }))
      .then(
    (response) {
      if (response.statusCode == 200) {
        print('Device Created Successfully');
      } else {
        throw Exception('Failed to update variable');
      }
    },
  );
}
