import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/ollama_service.dart';
import '../view_models/providers.dart';

class ModelsWidget extends ConsumerWidget {
  final String? selectedModel;
  final Function(String) onModelSelected;

  const ModelsWidget({
    required this.selectedModel,
    required this.onModelSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    try {
      final modelsAsyncValue = ref.watch(modelsProvider);

      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Model',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            modelsAsyncValue.when(
              data: (models) {
                if (models.isEmpty) {
                  // Render a TextField with the "No Models Found" message
                  return TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'No Models Found',
                      hintStyle: const TextStyle(color: Colors.white60),
                      filled: true,
                      fillColor: Colors.grey[800],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                }
                else
                  {
                // Render DropdownButton when models are available

                return DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.grey[800],
                  value: models.contains(selectedModel) ? selectedModel : null, // Validate selectedModel
                  onChanged: (value) {
                    if (value != null) {
                      onModelSelected(value);
                    }
                  },
                  items: models.isNotEmpty
                      ? models.map((model) {
                    return DropdownMenuItem(
                      value: model,
                      child: Text(
                        model,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }).toList()
                      : null, // Handle empty items
                );

              }
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              error: (error, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Failed to load models: $error',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(modelsProvider); // Retry fetching models
                      },
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
    } catch (e) {
      // Catch unexpected errors to avoid crashes
      return Center(
        child: Text(
          'Unexpected error occurred: $e',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }
}
