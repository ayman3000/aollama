import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../views/settings_view.dart';
import '../view_models/chat_view_model.dart';
// import '../models/session.dart';
import '../view_models/providers.dart';
import '../widgets/appbar_title_widget.dart';
import '../widgets/chat_header_widget.dart';
import '../widgets/chat_history_widget.dart';
import '../widgets/message_input_widget.dart';
import '../widgets/rotating_image_widget.dart';
import '../widgets/sidebar_widget.dart';

class HomeView extends ConsumerWidget {
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionList = ref.watch(sessionListProvider);
    final selectedSession = ref.watch(selectedSessionProvider);
    final chatHistory = ref.watch(chatHistoryProvider);
    final isLoading = ref.watch(chatViewModelProvider);
    final viewModel = ref.read(chatViewModelProvider.notifier);
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
                    baseUrl: ref.watch(baseUrlProvider),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      drawer: MediaQuery.of(context).size.width < 800 ? Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: SidebarWidget(
              sessionList: sessionList,
              // models: models,
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
      ):null,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Threshold for showing the sidebar
          const double sidebarThreshold = 800;
          final bool isWideScreen = constraints.maxWidth >= sidebarThreshold;

          return Row(
            children: [
              // Sidebar for Wide Screens
              if (isWideScreen)
                SizedBox(
                  width: 270, // Fixed width for sidebar
                  child: SidebarWidget(
                    sessionList: sessionList,
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

              // Main Content
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: 1200, // Set maximum width for the chat history content
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(
                        children: [
                          Column(
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
                                    onCopyResponse: (response) {
                                      ref.read(chatViewModelProvider.notifier).copyResponse(response).then((_) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Response copied!')),
                                        );
                                      }).catchError((error) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error copying response: $error')),
                                        );
                                      });
                                    },

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
                  ),
                ),
              ),
            ],
          );
        },
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
