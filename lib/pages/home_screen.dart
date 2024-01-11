import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _openDoor = false;
  final db = FirebaseFirestore.instance;

  Map<String, dynamic> mapCreateDoor({
    bool? statusDoor,
    DateTime? lastUpdate,
  }) {
    final firestoreData = (<String, dynamic>{
      'statusDoor': statusDoor,
      'lastUpdate': lastUpdate,
    });

    return firestoreData;
  }

  Future<void> createData() async {
    await db.collection('doors').add({
      'statusDoor': true,
      'lastUpdate': DateTime.now(),
    });
  }

  void getStatusDoor() async {
    var response =
        await db.collection('doors').doc("OCJtX1n28YrORFdmaoTD").get();

    bool result = response.data()!.values.first;

    setState(() {
      _openDoor = !result;
    });
  }

  Future<void> openDoor() async {
    await db.collection('doors').doc("OCJtX1n28YrORFdmaoTD").set({
      'statusDoor': true,
      'lastUpdate': DateTime.now(),
    }).then((value) => log("Successfully! Door is open"),
        onError: (e) => log("Error: $e"));
    ;
  }

  Future<void> closeDoor() async {
    await db.collection('doors').doc("OCJtX1n28YrORFdmaoTD").set({
      'statusDoor': false,
      'lastUpdate': DateTime.now(),
    }).then((value) => log("Successfully! Door is closed"),
        onError: (e) => log("Error: $e"));
    ;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    getStatusDoor();
  }

  //OCJtX1n28YrORFdmaoTD

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Icon(
                _openDoor ? Icons.door_back_door : Icons.door_sliding_outlined,
                size: 290,
                color: Colors.brown,
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_openDoor == true) {
                    setState(() {
                      _openDoor = false;
                      openDoor();
                    });
                  } else {
                    setState(() {
                      _openDoor = true;
                      closeDoor();
                    });
                  }
                },
                child: Text(_openDoor ? "Open the door" : "Close the door"))
          ],
        ),
      ),
    );
  }
}
