import 'dart:convert';

import 'package:chatbot/secret.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  final List<Map<String, String>> massages = [];

  Future<String> post(String prompt) async {
    massages.add({"role": "user", "content": prompt});
    try {
      final res = await http.post(
          Uri.parse("https://api.openai.com/v1/chat/completions"),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $APIKEY2"
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": "massages",
            "stream": true
          }));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (kDebugMode) {
          print(data);
        }
        return data['choices'][0]['message']['content'];
      } else {
        if (kDebugMode) {
          print("Error: ${res.statusCode} - ${res.body}");
        }
        return "Error: ${res.body}";
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return "Exception: $e";
    }
  }

  // void bard() {
  //   final model = GenerativeModel(model: "gemini-pro", apiKey: BARDAPI);
    
  // }
}
