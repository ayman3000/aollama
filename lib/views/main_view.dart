// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../view_models/chat_view_model.dart';
// import '../models/session.dart';
// import '../view_models/providers.dart';
// import '../widgets/chat_header_widget.dart';
// import '../widgets/chat_history_widget.dart';
// import '../widgets/message_input_widget.dart';
// import '../widgets/sidebar_widget.dart';
// import 'dart:ui';
//
// class MainView extends ConsumerWidget {
//   final ScrollController scrollController = ScrollController();
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final sessionList = ref.watch(sessionListProvider);
//     final selectedSession = ref.watch(selectedSessionProvider);
//     final chatHistory = ref.watch(chatHistoryProvider);
//     final isLoading = ref.watch(chatViewModelProvider); // Listen to loading state.
//     final viewModel = ref.read(chatViewModelProvider.notifier); // Access the ViewModel.
//     final models = ref.watch(modelListProvider);
//     final selectedModel = ref.watch(selectedModelProvider);
//     final isSidebarVisible = ref.watch(isSidebarVisibleProvider); // Sidebar visibility state.
//
//     final mediaQueryWidth = MediaQuery.of(context).size.width;
//     final threshold = 1300;
//
//     // Dynamically toggle sidebar visibility based on screen width
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (mediaQueryWidth <= threshold && isSidebarVisible) {
//         ref.read(isSidebarVisibleProvider.notifier).state = false;
//       } else if (mediaQueryWidth > threshold && !isSidebarVisible) {
//         ref.read(isSidebarVisibleProvider.notifier).state = true;
//       }
//     });
//
//     // Automatically select the first model if none is selected
//     if (models.isNotEmpty && selectedModel == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(selectedModelProvider.notifier).state = models.first;
//       });
//     }
//
//     // Automatically select the first session if none is selected
//     if (sessionList.isNotEmpty && selectedSession == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         ref.read(selectedSessionProvider.notifier).state = sessionList.first;
//         ref.read(chatViewModelProvider.notifier).loadChatHistory(sessionList.first.id);
//       });
//     }
//
//     return Scaffold(
//       drawer:               Expanded(
//         child: Row(
//           children: [
//             // if (isSidebarVisible)
//             SidebarWidget(
//               sessionList: sessionList,
//               models: models,
//               selectedSession: selectedSession,
//               selectedModel: selectedModel,
//               onModelSelected: (modelName) {
//                 ref.read(selectedModelProvider.notifier).state = modelName;
//               },
//               onNewSession: (name) async {
//                 try {
//                   await viewModel.addNewSession(name);
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(e.toString())),
//                   );
//                 }
//               },
//               onSessionSelected: (session) async {
//                 ref.read(selectedSessionProvider.notifier).state = session;
//                 await viewModel.loadChatHistory(session.id);
//                 scrollToBottom();
//               },
//             ),
//
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               // App Header
//               Container(
//                 color: Colors.black87,
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Placeholder for Logo
//                     Row(
//                       children: [
//                         Container(
//                           width: 40, // Adjust size as needed
//                           height: 40,
//                           color: Colors.grey[800], // Placeholder for logo
//                           child: const Center(
//                             child: Text(
//                               "Logo",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         // Placeholder for App Name
//                         const Text(
//                           "AOllama",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Row(
//                   children: [
//                     if (isSidebarVisible)
//                       SidebarWidget(
//                         sessionList: sessionList,
//                         models: models,
//                         selectedSession: selectedSession,
//                         selectedModel: selectedModel,
//                         onModelSelected: (modelName) {
//                           ref.read(selectedModelProvider.notifier).state = modelName;
//                         },
//                         onNewSession: (name) async {
//                           try {
//                             await viewModel.addNewSession(name);
//                           } catch (e) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text(e.toString())),
//                             );
//                           }
//                         },
//                         onSessionSelected: (session) async {
//                           ref.read(selectedSessionProvider.notifier).state = session;
//                           await viewModel.loadChatHistory(session.id);
//                           scrollToBottom();
//                         },
//                       ),
//                     if (isSidebarVisible)
//                       Container(
//                         width: 1.0, // Border width
//                         color: Colors.grey, // Border color
//                       ),
//                     Expanded(
//                       flex: isSidebarVisible ? 5 : 1, // Adjust flex based on sidebar visibility
//                       child: Column(
//                         children: [
//                           ChatHeaderWidget(selectedSession: selectedSession),
//                           Expanded(
//                             child: ChatHistoryWidget(
//                               chatHistory: chatHistory,
//                               scrollController: scrollController,
//                             ),
//                           ),
//                           MessageInputWidget(
//                             scrollController: scrollController,
//                             onSendMessage: (message) async {
//                               if (selectedSession != null) {
//                                 try {
//                                   await viewModel.sendMessage(message, selectedSession.id);
//                                   scrollToBottom();
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text(e.toString())),
//                                   );
//                                 }
//                               }
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           if (isLoading)
//             const Center(
//               child: CircularProgressIndicator(),
//             ),
//         ],
//       ),
//     );
//   }
//
//   void scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (scrollController.hasClients) {
//         scrollController.animateTo(
//           scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
// }