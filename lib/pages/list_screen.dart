import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_dors/models/door.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
        future: getDoorsCollection(db),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<DocumentSnapshot> doors = snapshot.data!.toList();

            return ListView.builder(
              itemCount: doors.length,
              itemBuilder: (context, index) {
                var doorData = doors[index].data() as Map<String, dynamic>;
                // Puedes personalizar cómo se muestra cada elemento en el ListView
                return ListTile(
                  leading: Icon(
                    doorData['statusDoor'] ?? false
                        ? Icons.door_sliding_outlined
                        : Icons.door_back_door,
                    size: 60,
                    color: Colors.brown,
                  ),
                  title: Text(doorData['statusDoor'] == true
                      ? "Puerta abierta"
                      : "Puerta cerrada"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat("dd/MM/yyyy HH:mm:ss").format(
                          doorData['lastUpdate'].toDate(),
                        ),
                      ),
                      Text(convertString(doorData['docRef'].toString())),
                      const Divider()
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
