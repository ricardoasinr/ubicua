import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_dors/models/door.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // bool _openDoor = false;
  final db = FirebaseFirestore.instance;

  Future<void> createData() async {
    await db.collection('doors').add({
      'statusDoor': true,
      'lastUpdate': DateTime.now(),
    });
  }

  Future<void> createData2() async {
    await db.collection('doors').add(mapCreateDoor(
          statusDoor: true,
          lastUpdate: DateTime.now(),
        ));
  }

  // void getStatusDoor() async {
  //   var response =
  //       await db.collection('doors').doc("OCJtX1n28YrORFdmaoTD").get();

  //   bool result = response.data()!["statusDoor"];

  //   setState(() {
  //     _openDoor = !result;
  //   });
  // }

  Future<void> openDoor() async {
    await db
        .collection('doors')
        .doc("OCJtX1n28YrORFdmaoTD")
        .set(mapCreateDoor(
          statusDoor: true,
          lastUpdate: DateTime.now(),
        ))
        .then((value) => log("Successfully! Door is open"),
            onError: (e) => log("Error: $e"));
    ;
  }

  Future<void> closeDoor() async {
    await db
        .collection('doors')
        .doc("OCJtX1n28YrORFdmaoTD")
        .set(mapCreateDoor(
          statusDoor: false,
          lastUpdate: DateTime.now(),
        ))
        .then((value) => log("Successfully! Door is closed"),
            onError: (e) => log("Error: $e"));
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // getStatusDoor();
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
      body: StreamBuilder<DocumentSnapshot>(
          stream:
              db.collection('doors').doc('OCJtX1n28YrORFdmaoTD').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var document = snapshot.data;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Icon(
                      // document!["statusDoor"]
                      document?["statusDoor"] ?? false
                          ? Icons.door_sliding_outlined
                          : Icons.door_back_door,
                      size: 290,
                      color: Colors.brown,
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if ((document?["statusDoor"] ?? false) == true) {
                          setState(() {
                            // _openDoor = false;
                            closeDoor();
                          });
                        } else {
                          setState(() {
                            // _openDoor = true;
                            openDoor();
                          });
                        }
                      },
                      child: Text(document?["statusDoor"] ?? false
                          ? "Close the door"
                          : "Open the door"))
                ],
              ),
            );
          }),
    );
  }
}
