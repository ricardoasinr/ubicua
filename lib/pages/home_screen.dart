import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _openDoor = false;

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
                size: 190,
                color: Colors.brown,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_openDoor == true) {
                    setState(() {
                      _openDoor = false;
                    });
                  } else {
                    setState(() {
                      _openDoor = true;
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
