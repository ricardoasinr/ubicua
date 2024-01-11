// ignore_for_file: avoid_print

import 'dart:math';

class Door {
  final bool statusDoor;
  final DateTime lastUpdate;

  Door({
    required this.statusDoor,
    required this.lastUpdate,
  });
}

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

Future<void> createData(final db) async {
  await db.collection('doors').add({
    'statusDoor': true,
    'lastUpdate': DateTime.now(),
  });
}

Future<void> createData2(final db) async {
  await db.collection('doors').add(mapCreateDoor(
        statusDoor: true,
        lastUpdate: DateTime.now(),
      ));
}

Future<void> openDoor(final db) async {
  await db
      .collection('doors')
      .doc("OCJtX1n28YrORFdmaoTD")
      .set(mapCreateDoor(
        statusDoor: true,
        lastUpdate: DateTime.now(),
      ))
      .then((value) => print("Successfully! Door is open"),
          onError: (e) => print("Error: $e"));
}

Future<void> closeDoor(final db) async {
  await db
      .collection('doors')
      .doc("OCJtX1n28YrORFdmaoTD")
      .set(mapCreateDoor(
        statusDoor: false,
        lastUpdate: DateTime.now(),
      ))
      .then((value) => print("Successfully! Door is closed"),
          onError: (e) => print("Error: $e"));
}
