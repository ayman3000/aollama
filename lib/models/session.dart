class Session {
  final int id;
  final String name;
  final DateTime? timestamp;

  Session({required this.id, required this.name, this.timestamp});

  factory Session.fromMap(Map<String, dynamic> map) {
    Session session = Session(
      id: map['id'],
      name: map['name'],
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'])
          : null,
    );
    print(session);
    return session;
  }
}


