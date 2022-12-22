// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:liquimech/access_token.dart';
import 'package:liquimech/add_device.dart' as addDevice;
import 'package:liquimech/main.dart' as main;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSwched = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    main.getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liquimech Devices List'),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn1",
        backgroundColor: Colors.red,
        onPressed: () {
          setState(() {
            devicesName = [];
            // getDevices();
            FutureBuilder(
              future: getDevices(),
              builder: (context, snapshot) {
                return ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: devicesName.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        devicesName[index],
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                );
              },
            );
          });
        },
        child: const Icon(Icons.devices),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Center(
              child: Text(
                'Fetching Data from Devices',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: Colors.red,
              child: const Icon(Icons.add),
              onPressed: () {
                // adding device navigation code will go here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const addDevice.AddDevice()),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
