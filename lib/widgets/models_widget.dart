import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModelsWidget extends StatelessWidget {
  final List<String> models;
  final String? selectedModel;
  final Function(String) onModelSelected;

  const ModelsWidget({
    required this.models,
    required this.selectedModel,
    required this.onModelSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
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
          Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  isExpanded: true, // Ensures the dropdown fills the available space
                  dropdownColor: Colors.grey[800],
                  value: selectedModel,
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
                      : [
                    const DropdownMenuItem(
                      value: null,
                      child: Text(
                        'No models available',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
