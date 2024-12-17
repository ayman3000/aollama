import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../view_models/providers.dart';

class OllamaService {
  final String baseUrl;

  OllamaService({this.baseUrl = 'http://192.168.1.4:11434'});

  Future<List<String>> getAvailableModels() async {
    final url = Uri.parse('$baseUrl/api/tags');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<String>.from(data['models'].map((model) => model['name']));
    }
    return [];
    // throw Exception('Failed to load models');
  }

  Future<Map<String, dynamic>> generateResponse(String modelName, String prompt) async {
    final url = Uri.parse('$baseUrl/api/generate');
    final body = json.encode({'model': modelName, 'prompt': prompt, 'stream': false});
    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to generate response');
  }
}

final ollamaServiceProvider = Provider<OllamaService>((ref) {
  final baseUrl = ref.watch(baseUrlProvider); // Watch the current base URL
  return OllamaService(baseUrl: baseUrl);    // Pass the dynamic base URL
});
