import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:open_dors/models/door.dart';
import 'package:open_dors/pages/list_screen.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final db = FirebaseFirestore.instance;
  // ignore: prefer_final_fields
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String _confidence = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _lastWords = "";
      _confidence = "";
    });
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _lastWords = "";
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = "";
      _lastWords = result.recognizedWords;

      print(_lastWords);
      if (result.recognizedWords.contains("Open the door")) {
        openDoor(db);
        createDataWithReference(db, true);
      }
      if (result.recognizedWords.contains("Close the door")) {
        closeDoor(db);
        createDataWithReference(db, false);
      }
      _confidence = ((result.confidence * 100).round()).toString();
    });
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
                          createDataWithReference(db, false);
                        });
                      } else {
                        setState(() {
                          openDoor(db);
                          createDataWithReference(db, true);
                        });
                      }
                    },
                    child: Text(document?["statusDoor"] ?? false
                        ? "Close the door"
                        : "Open the door"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: _speechToText.isNotListening
                          ? _startListening
                          : _stopListening,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_speechToText.isNotListening
                              ? Icons.mic_off
                              : Icons.mic),
                          const Text("Touch to speech")
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _speechToText.isListening
                          ? '$_lastWords '
                          : _speechEnabled
                              ? ''
                              : 'Speech not available',
                    ),
                  ),
                  _confidence == ""
                      ? Container()
                      : Text(_speechToText.isNotListening
                          ? "Similarity percentage: $_confidence%"
                          : ""),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ListScreen()),
                          );
                        },
                        child: const Text("Ver historial")),
                  )
                ],
              ),
            );
          }),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed:
      //       // If not yet listening for speech start, otherwise stop
      //       _speechToText.isNotListening ? _startListening : _stopListening,
      //   tooltip: 'Listen',
      //   child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      // ),
    );
  }
}
