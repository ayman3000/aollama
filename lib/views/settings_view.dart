import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  final TextEditingController _baseUrlController = TextEditingController();

  SettingsView({super.key, required String baseUrl}) {
    _baseUrlController.text = baseUrl; // Set the current base URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Base URL",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _baseUrlController,
              decoration: InputDecoration(
                hintText: "Enter Base URL",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final newBaseUrl = _baseUrlController.text.trim();
                if (newBaseUrl.isNotEmpty) {
                  // Save the new base URL (e.g., using shared preferences or state management)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Base URL updated successfully!"),
                    ),
                  );
                  Navigator.pop(context); // Go back to the previous screen
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Base URL cannot be empty."),
                    ),
                  );
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
