import 'package:flutter/material.dart';
import '../models/session.dart';
import 'models_widget.dart'; // Import ModelsWidget

class SidebarWidget extends StatelessWidget {
  final List<Session> sessionList;
  final Session? selectedSession;
  final List<String> models;
  final String? selectedModel;
  final Function(String) onModelSelected;
  final Function(String) onNewSession;
  final Function(Session) onSessionSelected;

  const SidebarWidget({
    required this.sessionList,
    required this.selectedSession,
    required this.models,
    required this.selectedModel,
    required this.onModelSelected,
    required this.onNewSession,
    required this.onSessionSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextEditingController for the input field
    final TextEditingController sessionController = TextEditingController();

    return Container(
      color: Colors.black87,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Models Dropdown Section

          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: ModelsWidget(
              models: models,
              selectedModel: selectedModel,
              onModelSelected: onModelSelected,
            ),
          ),

          // Create New Session Section
          const Text(
            'Create New Session',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: sessionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter session name',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (name) {
                    if (name.trim().isNotEmpty) {
                      onNewSession(name.trim());
                      sessionController.clear(); // Clear the input field
                    }
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  final name = sessionController.text.trim();
                  if (name.isNotEmpty) {
                    onNewSession(name); // Call the callback function
                    sessionController.clear(); // Clear the input field
                  } else {
                    // Optionally, show an error/snackbar for empty input
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Session name cannot be empty'),
                      ),
                    );
                  }
                },
              ),
            ],
          ),

          // Session History Section
          const Divider(color: Colors.grey, height: 20),
          const Text(
            'Session History',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          // const SizedBox(height: 10),
          const Divider(color: Colors.white,),
          Container(
            height:  MediaQuery.of(context).size.height * 0.69,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.grey[700]!),
              borderRadius: BorderRadius.circular(2),
            ),
            child: ListView.builder(
              itemCount: sessionList.length,
              itemBuilder: (context, index) {
                final session = sessionList[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: session == selectedSession
                        ? Colors.grey[800]
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(4), // Rectangle with slight rounding
                    border: session == selectedSession
                        ? Border.all(
                      // color: Colors.redAccent,
                      width: 1,
                    )
                        : null,
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      onSessionSelected(session);
                    },
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        session.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
