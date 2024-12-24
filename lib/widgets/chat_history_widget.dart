import 'package:aollama/app_colors.dart';
import 'package:aollama/models/message.dart';
import 'package:flutter/material.dart';
import 'message_body.dart';

class ChatHistoryWidget extends StatelessWidget {
  final List<Message> chatHistory;
  final ScrollController scrollController;
  final Function(String) onCopyResponse;

  const ChatHistoryWidget({
    required this.chatHistory,
    required this.scrollController,
    required this.onCopyResponse,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: chatHistory.length,
        itemBuilder: (context, index) {
          final conversation = chatHistory[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MessageBubble(
                isUser: true,
                avatarIcon: Icons.account_circle_rounded,
                backgroundColor: AppColors.userMessageBackground,
                content: conversation.userInput,
                onCopy: () => onCopyResponse(conversation.userInput),
              ),
              const SizedBox(height: 10),
              MessageBubble(
                isUser: false,
                avatarIcon: Icons.laptop,
                backgroundColor: AppColors.botMessageBackground,
                content: '${conversation.modelName}: ${conversation.botResponse}',
                onCopy: () => onCopyResponse(conversation.botResponse),
              ),
            ],
          );
        },
      ),
    );
  }
}