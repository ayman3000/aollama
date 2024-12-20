class Message {
  final int sessionId; // The ID of the session this message belongs to
  final String userInput; // User's input message
  final String botResponse; // Bot's response
  final String modelName; // Name of the model used
  final DateTime? timestamp; // When the message was created
  final double? responseTime; // Time taken to generate the response

  Message({
    required this.sessionId,
    required this.userInput,
    required this.botResponse,
    required this.modelName,
    this.timestamp,
    this.responseTime,
  });

  // Convert from a map to a Message object
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sessionId: map['session_id'],
      userInput: map['user_input'],
      botResponse: map['bot_response'],
      modelName: map['model_name'],
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'])
          : null,
      responseTime: (map['response_time'] as num?)?.toDouble(),
    );
  }

  // Convert a Message object to a map
  Map<String, dynamic> toMap() {
    return {
      'session_id': sessionId,
      'user_input': userInput,
      'bot_response': botResponse,
      'model_name': modelName,
      'timestamp': timestamp?.toIso8601String(),
      'response_time': responseTime,
    };
  }
}
