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
