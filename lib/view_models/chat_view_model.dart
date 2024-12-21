import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/message.dart';
import '../models/session.dart';
import '../services/database_service.dart';
import '../services/ollama_service.dart';
import '../view_models/providers.dart';



class ChatViewModel extends StateNotifier<bool> {
  final  _read;

  ChatViewModel(this._read) : super(false); // Initialize with `isLoading` as false.

  Future<void> addNewSession(String name) async {
    final databaseService = _read(databaseServiceProvider);
    final sessionListNotifier = _read(sessionListProvider.notifier);
    final selectedSessionNotifier = _read(selectedSessionProvider.notifier);
    final chatViewModelNotifier = _read(chatViewModelProvider.notifier);

    final sessionId = await databaseService.createSession(name);
    if (sessionId != null) {
      final newSession = Session(id: sessionId, name: name, timestamp: DateTime.timestamp());
      // await databaseService.updateLastActivityDate(sessionId);

      try {
        sessionListNotifier.state = [newSession,
          ...sessionListNotifier.state as List<Session>,

        ];
      }
      catch(e){
        print(e.toString());
      }
      selectedSessionNotifier.state = newSession;
      await loadChatHistory(newSession.id);

    } else {
      throw Exception('Session name already exists!');
    }
  }

  Future<void> loadChatHistory(int sessionId) async {
    final databaseService = _read(databaseServiceProvider);
    final chatHistoryNotifier = _read(chatHistoryProvider.notifier);

    try {
      final history = await databaseService.loadMessageHistory(sessionId);
      if (history.isNotEmpty) {
        chatHistoryNotifier.loadHistory(history);

      } else {
        chatHistoryNotifier.clearHistory();
      }
    } catch (error) {
      print('Error loading chat history: $error');
    }
  }

  Future<void> sendMessage(String message, int sessionId) async {
    final ollamaService = _read(ollamaServiceProvider);
    final databaseService = _read(databaseServiceProvider);
    final chatHistoryNotifier = _read(chatHistoryProvider.notifier);
    final selectedModel = _read(selectedModelProvider);
    final sessionListNotifier = _read(sessionListProvider.notifier);
    final selectedSessionNotifier = _read(selectedSessionProvider.notifier); // To update selected session

    if (selectedModel == null || message.trim().isEmpty) {
      throw Exception('Please select a model and enter a message!');
    }

    state = true; // Set `isLoading` to true.
    final startTime = DateTime.now();

    try {

      List<Map<String, String>> messages= [
        {'role':'user', 'content':message}
      ];
      final response = await ollamaService.chatResponse(selectedModel, messages);

      // final response = await ollamaService.generateResponse(selectedModel, message);
      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds / 1000.0;

      final newMessage = Message(
        sessionId : sessionId ,
        userInput: message,
        botResponse: response['message']['content'],
        modelName: selectedModel,
        timestamp: DateTime.now(),
        responseTime: responseTime,
      );

      // Save conversation in the database
      await databaseService.saveMessage({
        'session_id': sessionId,
        'model_name': selectedModel,
        'user_input': message,
        'bot_response': response['message']['content'],
        'response_time': responseTime,
        'timestamp': DateTime.now().toIso8601String(),
      });


      // Add new message to chat history
      chatHistoryNotifier.addMessage(newMessage);
      // Refresh the session list
      final updatedSessions = await databaseService.loadSessions();
      sessionListNotifier.state = updatedSessions; // Update the session list
      // Update the selected session to the first one
      if (updatedSessions.isNotEmpty) {
        selectedSessionNotifier.state = updatedSessions.first;
        // await loadChatHistory(updatedSessions.first.id); // Load chat history for the first session
      }

    } catch (error) {
      throw Exception('Failed to send message: $error');
    } finally {
      state = false; // Set `isLoading` to false.
    }
  }

  Future<void> copyResponse(String response) async {
    try {
      await Clipboard.setData(ClipboardData(text: response));
    } catch (error) {
      throw Exception('Failed to copy response: $error');
    }
  }
}



final chatViewModelProvider = StateNotifierProvider<ChatViewModel, bool>((ref) {
  return ChatViewModel(ref.read);
});