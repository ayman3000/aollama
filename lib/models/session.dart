class Session {
  final int id;
  final String name;
  final DateTime? timestamp;
  final DateTime? lastActivityDate; // New field

  Session({
    required this.id,
    required this.name,
    this.timestamp,
    this.lastActivityDate,
  });



factory Session.fromMap(Map<String, dynamic> map) {
    Session session = Session(
      id: map['id'],
      name: map['name'],
      timestamp: map['timestamp'] != null
          ? DateTime.tryParse(map['timestamp'])
          : null,
      lastActivityDate: map['lastActivityDate'] != null
          ? DateTime.tryParse(map['lastActivityDate'])
          : null,
    );
    print(session);
    return session;
  }
}


