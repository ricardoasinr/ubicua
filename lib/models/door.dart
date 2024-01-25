import 'package:cloud_firestore/cloud_firestore.dart';

class Door {
  final bool statusDoor;
  final DateTime lastUpdate;

  Door({
    required this.statusDoor,
    required this.lastUpdate,
  });
}

Map<String, dynamic> mapCreateDoor({
  DocumentReference? docRef,
  bool? statusDoor,
  DateTime? lastUpdate,
}) {
  final firestoreData = (<String, dynamic>{
    'docRef': docRef,
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

Future<void> createDataWithReference(final db, bool status) async {
  DocumentReference documentReference =
      db.collection('doors').doc('OCJtX1n28YrORFdmaoTD');

  await db.collection('history').add(
        mapCreateDoor(
          docRef: documentReference,
          statusDoor: status,
          lastUpdate: DateTime.now(),
        ),
      );
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

Future<List<DocumentSnapshot>> getDoorsCollection(final db) async {
  QuerySnapshot querySnapshot = await db
      .collection('history')
      .orderBy('lastUpdate', descending: true)
      .get();
  return querySnapshot.docs;
}

String convertString(String ref) {
  return ref.toString().replaceAll(")", "").substring(40);
}
