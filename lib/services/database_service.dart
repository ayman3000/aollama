import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/message.dart';
import '../models/session.dart';
import '../models/session.dart';
import '../view_models/providers.dart';

class DatabaseService {
  static const String sessionsBoxName = 'sessionsBox';
  static const String messagesBoxName = 'messagesBox';

  // Initialize Hive and open necessary boxes
  Future<void> initializeDatabase() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(SessionAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(MessageAdapter());
    }

    // await resetDatabase();

    try {
      await Hive.openBox<Session>(DatabaseService.sessionsBoxName);
      await Hive.openBox<Message>(DatabaseService.messagesBoxName);
      print('Hive boxes opened successfully');
    } catch (e) {
      print('Error opening Hive boxes: $e');
      // Optionally reset boxes here if corruption is detected
    }
  }


  // Create a new session
  Future<int?> createSession(String name) async {
    final sessionsBox = Hive.box<Session>(sessionsBoxName);

    // Check for duplicate session names
    if (sessionsBox.values.any((session) => session.name == name)) {
      print('Error: Duplicate session name');
      return null;
    }

    final newSession = Session(
      id: sessionsBox.length,
      name: name,
      timestamp: DateTime.now(),
    );

    await sessionsBox.put(newSession.id, newSession);
    return newSession.id;
  }

  // Load all sessions
  Future<List<Session>> loadSessions() async {
    final sessionsBox = Hive.box<Session>(sessionsBoxName);

    return sessionsBox.values.toList()
      ..sort((a, b) {
        final aTimestamp = a.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0); // Fallback to epoch
        final bTimestamp = b.timestamp ?? DateTime.fromMillisecondsSinceEpoch(0); // Fallback to epoch
        return bTimestamp.compareTo(aTimestamp); // Sort descending
      });
  }

  // Save a message
  Future<void> saveMessage(int sessionId, Message message) async {
    final messagesBox = Hive.box<Message>(messagesBoxName);

    await messagesBox.add(
      Message(
        sessionId: sessionId,
        userInput: message.userInput,
        botResponse: message.botResponse,
        modelName: message.modelName,
        timestamp: message.timestamp ?? DateTime.now(),
        responseTime: message.responseTime ?? 0.0,
      ),
    );
  }

  // Load message history for a specific session
  Future<List<Message>> loadMessageHistory(int sessionId) async {
    final messagesBox = Hive.box<Message>(messagesBoxName);

    return messagesBox.values
        .where((message) => message.sessionId == sessionId)
        .toList()
      ..sort((a, b) => a.timestamp?.compareTo(b.timestamp ?? DateTime.now()) ?? 0);
  }

  Future<void> resetDatabase() async {
    await Hive.deleteBoxFromDisk(DatabaseService.sessionsBoxName);
    await Hive.deleteBoxFromDisk(DatabaseService.messagesBoxName);
  }

}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 0;

  @override
  Session read(BinaryReader reader) {
    return Session(
      id: reader.readInt(),
      name: reader.readString(),
      timestamp: reader.read() as DateTime?, // Read DateTime directly
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.write(obj.timestamp); // Write DateTime directly
  }
}


  @override
  void write(BinaryWriter writer, Session obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.timestamp?.toIso8601String() ?? ''); // Write empty string if null
  }


// Hive adapter for the Message class
class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 1;

  @override
  Message read(BinaryReader reader) {
    return Message(
      sessionId: reader.readInt(),
      userInput: reader.readString(),
      botResponse: reader.readString(),
      modelName: reader.readString(),
      timestamp: reader.read() as DateTime?, // Read DateTime directly
      responseTime: reader.readDouble(),
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeInt(obj.sessionId);
    writer.writeString(obj.userInput);
    writer.writeString(obj.botResponse);
    writer.writeString(obj.modelName);
    writer.write(obj.timestamp); // Write DateTime directly
    writer.writeDouble(obj.responseTime ?? 0.0);
  }
}
