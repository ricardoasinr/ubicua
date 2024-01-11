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
  final db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
  }

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
                            closeDoor(db);
                          });
                        } else {
                          setState(() {
                            openDoor(db);
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
