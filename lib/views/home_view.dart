import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ollama_client/views/settings_view.dart';
import '../view_models/chat_view_model.dart';
import '../models/session.dart';
import '../view_models/session_provider.dart';
import '../widgets/appbar_title_widget.dart';
import '../widgets/chat_header_widget.dart';
import '../widgets/chat_history_widget.dart';
import '../widgets/message_input_widget.dart';
import '../widgets/rotating_image_widget.dart';
import '../widgets/sidebar_widget.dart';
import 'dart:ui';

class HomeView extends ConsumerWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionList = ref.watch(sessionListProvider);
    final selectedSession = ref.watch(selectedSessionProvider);
    final chatHistory = ref.watch(chatHistoryProvider);
    final isLoading = ref.watch(chatViewModelProvider); // Listen to loading state.
    final viewModel = ref.read(chatViewModelProvider.notifier); // Access the ViewModel.
    final models = ref.watch(modelListProvider);
    final selectedModel = ref.watch(selectedModelProvider);

    // Automatically select the first model if none is selected
    if (models.isNotEmpty && selectedModel == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedModelProvider.notifier).state = models.first;
      });
    }

    // Automatically select the first session if none is selected
    if (sessionList.isNotEmpty && selectedSession == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedSessionProvider.notifier).state = sessionList.first;
        ref.read(chatViewModelProvider.notifier).loadChatHistory(sessionList.first.id);
      });
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        backgroundColor: Colors.black87,
        title: const AppBarTitleWidget(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsView(
                    baseUrl: ref.watch(baseUrlProvider), // Replace with current base URL
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: SidebarWidget(
              sessionList: sessionList,
              models: models,
              selectedSession: selectedSession,
              selectedModel: selectedModel,
              onModelSelected: (modelName) {
                ref.read(selectedModelProvider.notifier).state = modelName;
              },
              onNewSession: (name) async {
                try {
                  await viewModel.addNewSession(name);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }
              },
              onSessionSelected: (session) async {
                ref.read(selectedSessionProvider.notifier).state = session;
                await viewModel.loadChatHistory(session.id);
                scrollToBottom();
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            // Gradient Background
            Center(
              child: ConstrainedBox(
                constraints:BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6, )
                ,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.black87, Colors.black],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Chat Header
                      ChatHeaderWidget(selectedSession: selectedSession),
                      // Chat History
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.9),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 8,
                                offset: const Offset(0, -2),
                              ),
                            ],
                          ),
                          child: ChatHistoryWidget(
                            chatHistory: chatHistory,
                            scrollController: scrollController,
                          ),
                        ),
                      ),
                      // Message Input
                      MessageInputWidget(
                        scrollController: scrollController,
                        onSendMessage: (message) async {
                          if (selectedSession != null) {
                            try {
                              await viewModel.sendMessage(message, selectedSession.id);
                              scrollToBottom();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(e.toString()),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Loading Indicator
            if (isLoading)
              const Center(
                child: RotatingImageWidget(
                  imagePath: 'assets/logo.png',
                  size: 80.0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
