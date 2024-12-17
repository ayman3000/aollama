import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageInputWidget extends StatelessWidget {
  final ScrollController scrollController;
  final Function(String) onSendMessage;

  const MessageInputWidget({
    required this.scrollController,
    required this.onSendMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final FocusNode focusNode = FocusNode();

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16.0),
      child: RawKeyboardListener(
        focusNode: focusNode,
        onKey: (RawKeyEvent event) {
          if (event.isKeyPressed(LogicalKeyboardKey.enter) && !event.isShiftPressed) {
            final text = messageController.text.trim();
            if (text.isNotEmpty) {
              onSendMessage(text);
              messageController.clear();
            }
          }
        },
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: messageController,
                maxLines: null, // Allows the TextField to expand vertically
                keyboardType: TextInputType.multiline, // Enables multiline input
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Write your message...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () {
                final text = messageController.text.trim();
                if (text.isNotEmpty) {
                  onSendMessage(text);
                  messageController.clear();
                }
              },
              icon: const Icon(
                Icons.send,
                color: Colors.blue, // A nice, suitable color for the send icon
              ),
              tooltip: 'Send Message',
            ),
          ],
        ),
      ),
    );
  }
}
