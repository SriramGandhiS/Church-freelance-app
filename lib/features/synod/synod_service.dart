import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class SynodService {
  SynodService._();

  // This is the active Apps Script deployment
  static const String _baseUrl =
      'https://script.google.com/macros/s/AKfycbxYPAHaWmCB7VfGo-AOJQyW0lhmP8UwEPqOAcMCSZD9iVNBN5i340f-ymZD1pY7ereW/exec';

  static Future<List<Map<String, dynamic>>> fetchSynodMembers() async {
    try {
      final uri = Uri.parse('$_baseUrl?action=getSynodMembers');
      
      // Follow redirects to get the payload successfully
      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Server error: ${response.statusCode}');
      }

      if (response.body.contains('<html') || response.body.contains('<HTML')) {
        debugPrint('APPS SCRIPT ERROR HTML: ${response.body}');
        throw Exception('Apps Script returned an HTML error screen. Make sure you deployed a new version of the script!');
      }

      final decoded = jsonDecode(response.body);
      
      if (decoded['status'] == 'error') {
        throw Exception(decoded['message']);
      }

      final List<dynamic> list = decoded['data'] ?? [];
      
      return list.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('SYNOD FETCH ERROR: $e');
      return []; // Return empty list rather than breaking UI on fetch crash
    }
  }
}
