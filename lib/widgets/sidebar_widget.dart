import 'package:aollama/widgets/platform_widgets/platform_text.dart';
import 'package:aollama/widgets/platform_widgets/platform_text_button.dart';

import 'platform_widgets/platform_textfield.dart';
import 'package:flutter/material.dart';
import '../models/session.dart';
import 'models_widget.dart'; // Import ModelsWidget

class SidebarWidget extends StatelessWidget {
  final List<Session> sessionList;
  final Session? selectedSession;
  final String? selectedModel;
  final Function(String) onModelSelected;
  final Function(String) onNewSession;
  final Function(Session) onSessionSelected;

  const SidebarWidget({
    required this.sessionList,
    required this.selectedSession,
    required this.selectedModel,
    required this.onModelSelected,
    required this.onNewSession,
    required this.onSessionSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController sessionController = TextEditingController();
    final ScrollController scrollController = ScrollController();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey.shade900, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Adjust to shrink-wrap its children
        children: [
          // Models Dropdown Section
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: ModelsWidget(
              selectedModel: selectedModel,
              onModelSelected: onModelSelected,
            ),
          ),

          // Create New Session Section
          PlatformText(
            text: 'Create New Session',
            // style: TextStyle(
            //   fontSize: 18,
            //   color: Colors.white,
            //   fontWeight: FontWeight.bold,
            // ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: PlatformTextField(
                  controller: sessionController,
                  placeholder: 'Enter session name',
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Enter session name',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.grey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onSubmitted: (name) {
                    if (name.trim().isNotEmpty) {
                      onNewSession(name.trim());
                      sessionController.clear();
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
                    onNewSession(name);
                    sessionController.clear();
                  } else {
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
          PlatformText(
            text: 'Session History',
            // style: TextStyle(
            //   fontSize: 18,
            //   color: Colors.white,
            //   fontWeight: FontWeight.bold,
            // ),
          ),
          const Divider(color: Colors.white),

          // Constrained Session List
          Flexible(
            fit: FlexFit.loose, // Allow flexibility without forcing full expansion
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.grey[900]?.withOpacity(0.9),
              ),
              child: Scrollbar(
                controller: scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: sessionList.length,
                  itemBuilder: (context, index) {
                    final session = sessionList[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: session == selectedSession
                            ? Colors.blueGrey
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: PlatformTextButton(
                        // style: TextButton.styleFrom(
                        //   padding: const EdgeInsets.symmetric(
                        //       vertical: 12, horizontal: 8),
                          foregroundColor: Colors.white,
                        // ),
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
            ),
          ),
        ],
      ),
    );
  }
}
