import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ollama_service.dart';
import '../view_models/providers.dart'; // Import the service provider

class SettingsView extends ConsumerWidget {
  final TextEditingController _baseUrlController = TextEditingController();

  SettingsView({super.key, required String baseUrl}) {
    _baseUrlController.text = baseUrl;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                final newUrl = _baseUrlController.text.trim();
                if (newUrl.isNotEmpty) {
                  ref.read(baseUrlProvider.notifier).state = newUrl;
                  ref.invalidate(modelsProvider); // Trigger models re-fetch
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Base URL updated!')),
                  );
                    Navigator.pop(context); // Go back to the previous screen

                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Base URL cannot be empty!')),
                  );
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text("Base URL updated successfully!")),
                //   );
                //   Navigator.pop(context); // Go back to the previous screen
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(content: Text("Base URL cannot be empty.")),
                //   );
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
