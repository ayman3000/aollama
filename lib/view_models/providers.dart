import 'package:aollama/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/database_service.dart';
import '../services/ollama_service.dart';

final selectedSessionProvider = StateProvider<Session?>((ref) => null);
final selectedModelProvider = StateProvider<String?>((ref) => null);
final isLoadingProvider = StateProvider<bool>((ref) => false);
final isSidebarVisibleProvider = StateProvider<bool>((ref) => true);
final baseUrlProvider = StateProvider<String>((ref) => 'http://localhost:11434');


class ChatHistoryNotifier extends StateNotifier<List<Message>> {
   ChatHistoryNotifier() : super([]);

  // Load chat history for a specific session
  void loadHistory(List<Message> history) {
    state = history; // Set the state with the loaded history
  }

  // Add a new conversation to the chat history
  void addMessage(Message conversation) {
    state = [...state, conversation]; // Append the new conversation to the history
  }

  // Clear the chat history (e.g., when switching sessions)
  void clearHistory() {
    state = [];
  }
}

final chatHistoryProvider = StateNotifierProvider<ChatHistoryNotifier, List<Message>>(
      (ref) => ChatHistoryNotifier(),
);


final sessionListProvider = StateNotifierProvider<SessionListNotifier, List<Session>>(
      (ref) {
    final databaseService = ref.read(databaseServiceProvider);
    final notifier = SessionListNotifier(databaseService);

    // Load sessions on initialization
    notifier.loadSessions();
    return notifier;
  },
);

final modelListProvider = StateNotifierProvider<ModelListNotifier, List<String>>(
      (ref) {
    final ollamaService = ref.read(ollamaServiceProvider);
    final notifier = ModelListNotifier(ollamaService);

    // Load sessions on initialization
    notifier.loadModels();
    return notifier;
  },
);



class SessionListNotifier extends StateNotifier<List<Session>> {
  final DatabaseService databaseService;

  SessionListNotifier(this.databaseService) : super([]);

  // Load sessions from the database
  Future<void> loadSessions() async {
    final sessionData = await databaseService.loadSessions();
    state = sessionData;
  }
}

class ModelListNotifier extends StateNotifier<List<String>> {
  final OllamaService ollamaService;

  ModelListNotifier(this.ollamaService) : super([]);

  // Load sessions from the database
  Future<void> loadModels() async {
    final modelData = await ollamaService.getAvailableModels();
    state = modelData;
  }


}

// final modelsProvider = FutureProvider<List<String>>((ref) async {
//   final ollamaService = ref.watch(ollamaServiceProvider);
//   return ollamaService.getAvailableModels();
// });

final modelsProvider = FutureProvider<List<String>>((ref) async {
  try {
    final baseUrl = ref.watch(baseUrlProvider); // Watch the base URL
    final ollamaService = OllamaService(baseUrl: baseUrl);
    return await ollamaService.getAvailableModels();
  }
  catch(e){
    return [];
  }
});
