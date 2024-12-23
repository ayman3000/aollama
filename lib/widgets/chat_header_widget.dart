import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/session.dart';

class ChatHeaderWidget extends StatelessWidget {
  final Session? selectedSession;
  final bool isMinThreshold;

  const ChatHeaderWidget({required this.isMinThreshold, required this.selectedSession, super.key});

  @override
  Widget build(BuildContext context) {

          return isMinThreshold ? Container(
            decoration: BoxDecoration(
              color: Colors.grey[830],
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey[700]!,
                  width: 1.0,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Session Title
                const Text(
                  'Active Session - ',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  selectedSession?.name ?? "No Session Selected",
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Action Button (Optional)
                // IconButton(
                //   onPressed: () {
                //     // Action for refresh or settings
                //   },
                //   icon: const Icon(Icons.refresh, color: Colors.white),
                //   tooltip: "Refresh",
                // ),
              ],
            ),
          ):Text('');
  }
}
