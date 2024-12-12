import 'package:flutter/material.dart';

class MessageInputWidget extends StatelessWidget {
  final ScrollController scrollController;
  final Function(String) onSendMessage;
   // TextEditingController messageController; // Add the controller for external use

  const MessageInputWidget({
    required this.scrollController,
    required this.onSendMessage,
    // required this.messageController, // Receive the controller as a parameter
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,

              decoration: InputDecoration(
                hintText: 'Write your message...',
                filled: true,
                fillColor: Colors.grey[700],
                hintStyle: const TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (text) {
                if (text.trim().isNotEmpty) {
                  onSendMessage(text.trim());
                  messageController.clear();
                }
              },
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              final text = messageController.text.trim();
              if (text.isNotEmpty) {
                onSendMessage(text);
                messageController.clear();
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}
