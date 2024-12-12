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



class Conversation {
  final String userInput;
  final String botResponse;
  final String modelName;
  final DateTime timestamp;
  final double responseTime;

  Conversation({
    required this.userInput,
    required this.botResponse,
    required this.modelName,
    required this.timestamp,
    required this.responseTime,
  });

  // Convert from database map (snake_case) to Conversation object
  factory Conversation.fromMap(Map<String, dynamic> map) {
    return Conversation(
      userInput: map['user_input'],
      botResponse: map['bot_response'],
      modelName: map['model_name'],
      timestamp: DateTime.parse(map['timestamp']),
      responseTime: map['response_time'],
    );
  }

  // Convert from Conversation object to database map (snake_case)
  Map<String, dynamic> toMap() {
    return {
      'user_input': userInput,
      'bot_response': botResponse,
      'model_name': modelName,
      'timestamp': timestamp.toIso8601String(),
      'response_time': responseTime,
    };
  }
}