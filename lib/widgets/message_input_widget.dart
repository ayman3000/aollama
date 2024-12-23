import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MessageInputWidget extends StatelessWidget {
  final ScrollController scrollController;
  final Function(String) onSendMessage;
  final bool isMinHeightThreshold;
  final bool isMinWidthThreshold;
  
  const MessageInputWidget({
    required this.scrollController,
    required this.onSendMessage,
    required this.isMinWidthThreshold,
    required this.isMinHeightThreshold,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    final FocusNode focusNode = FocusNode();


    return (isMinWidthThreshold || !isMinHeightThreshold) ? Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16.0),
      child: Focus(
        focusNode: focusNode,
        onKey: (FocusNode node, RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            final isShiftPressed = event.isShiftPressed;

            if (event.logicalKey == LogicalKeyboardKey.enter && !isShiftPressed) {
              // Submit the message
              final text = messageController.text.trim();
              if (text.isNotEmpty) {
                onSendMessage(text);
                messageController.clear();
              }
              return KeyEventResult.handled;
            } else if (event.logicalKey == LogicalKeyboardKey.enter && isShiftPressed) {
              // Add a new line
              final currentText = messageController.text;
              final newCursorPosition = messageController.selection.baseOffset + 1;
              messageController.text = '$currentText\n';
              messageController.selection = TextSelection.collapsed(offset: newCursorPosition);
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Row(
          children: [
            Expanded(
              child:
              SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 200, // Set a maximum height
                  ),
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
                    onSubmitted: (text)  {
                      print("submitted: $text");
                      onSendMessage(text);
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color of the circle
                shape: BoxShape.circle, // Make it a circle
              ),
              child: IconButton(
                iconSize: 30,
                highlightColor: Colors.blue,
                onPressed: () {
                  final text = messageController.text.trim();
                  if (text.isNotEmpty) {
                    onSendMessage(text);
                    messageController.clear();
                  }
                },
                icon: const Icon(
                  Icons.arrow_upward_outlined,
                  color: Colors.grey,
                  // A nice, suitable color for the send icon
                ),
                tooltip: 'Send Message',
              ),
            ),
          ],
        ),
      ),
    ):Text('');
  }

}
