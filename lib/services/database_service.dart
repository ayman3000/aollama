import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ollama_client/models/session.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../view_models/session_provider.dart';

class DatabaseService {
  Future<Database> initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat_history.db');

    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE session (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
          )
        ''');
        db.execute('''
          CREATE TABLE conversations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            session_id INTEGER,
            model_name TEXT,
            user_input TEXT,
            bot_response TEXT,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            response_time REAL,
            FOREIGN KEY (session_id) REFERENCES session(id)
          )
        ''');
      },
      version: 1,
    );
  }

  // Create a new session
  Future<int?> createSession(String name) async {
    final db = await initializeDatabase();
    try {
      // Insert the new session into the database
      final id = await db.insert('session', {'name': name});
      return id; // Return the session ID if successful
    } catch (e) {
      // Handle duplicate session names or other errors
      print('Error creating session: $e');
      return null; // Return null if there's an error
    }
  }

  Future<List<Session>> loadSessions() async {
    final db = await initializeDatabase();
    final maps = await db.query('session', orderBy: 'timestamp DESC');

    // Ensure every map is correctly parsed
    final sessions = maps.map((map) {
      try {
        return Session.fromMap(map);
      } catch (e) {
        print('Error parsing session: $e');
        return null; // Handle gracefully
      }
    }).whereType<Session>().toList();

    return sessions;
  }


  Future<List<Map<String, dynamic>>> loadSessions2() async {
    final db = await initializeDatabase();
    final result = await db.query('session', orderBy: 'timestamp DESC');

    // Optionally remove the `timestamp` field if not needed
    return result.map((map) {
      map.remove('timestamp'); // Remove timestamp if necessary
      return map;
    }).toList();
  }


  Future<void> saveConversation(Map<String, dynamic> conversation) async {
    final db = await initializeDatabase();
    int result = await db.insert('conversations', conversation);
    print("result={result}");
  }

  // Future<List<Conversation>> loadConversationHistory(int sessionId) async {
  //   final db = await initializeDatabase();
  //   final result = db.query(
  //     'conversations',
  //     where: 'session_id = ?',
  //     whereArgs: [sessionId],
  //     orderBy: 'timestamp ASC',
  //   );
  //
  //   return result;
  // }

  Future<List<Conversation>> loadConversationHistory(int sessionId) async {
    try {
      final db = await initializeDatabase();
      final result = await db.query(
        'conversations',
        where: 'session_id = ?',
        whereArgs: [sessionId],
      );

      // Ensure the result is mapped correctly
      return result.map<Conversation>((row) {
        return Conversation(
          userInput: row['user_input']?.toString() ?? '',
          botResponse: row['bot_response']?.toString() ?? '',
          modelName: row['model_name']?.toString() ?? '',
          timestamp: DateTime.tryParse(row['timestamp']?.toString() ?? '') ??
              DateTime.now(),
          responseTime: (row['response_time'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();
    } catch (error) {
      print('Error loading chat history: $error');
      // Return an empty list in case of an error
      return <Conversation>[];
    }
  }
}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});