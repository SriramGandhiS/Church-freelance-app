import 'dart:convert';
import 'package:http/http.dart' as http;
import 'application_model.dart';
import 'package:flutter/foundation.dart';

class ApplicationAdminService {
  ApplicationAdminService._();

  static const String _baseUrl =
      'https://script.google.com/macros/s/AKfycbxYPAHaWmCB7VfGo-AOJQyW0lhmP8UwEPqOAcMCSZD9iVNBN5i340f-ymZD1pY7ereW/exec';

  static Future<List<ApplicationRecord>> fetchAll() async {
    try {
      final uri = Uri.parse(_baseUrl);
      // Apps Script GET might redirect. http handles GET redirects fine.
      final response = await http.get(uri).timeout(const Duration(seconds: 20));

      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Server error: ${response.statusCode}');
      }

      // Check if it's returning HTML instead of JSON (error page)
      if (response.body.contains('<html') || response.body.contains('<HTML')) {
        debugPrint('APPS SCRIPT ERROR HTML: ${response.body}');
        throw Exception('Backend returned HTML (Script Error or Auth required). Please redeploy the Google Apps Script.');
      }

      final decoded = jsonDecode(response.body);
      final List<dynamic> list = decoded is List
          ? decoded
          : (decoded['data'] as List<dynamic>? ?? []);

      return list
          .map((item) => ApplicationRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('FETCH ERROR: $e');
      throw Exception('Failed to fetch data. Is the Apps Script correctly deployed? ($e)');
    }
  }

  static Future<void> verify(String id) async {
    final uri = Uri.parse(_baseUrl);
    // POST to Apps Script usually returns 302.
    final request = http.Request('POST', uri)
      ..followRedirects = false
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({'type': 'verify', 'id': id, 'verification_status': 'VERIFIED'});
      
    final response = await http.Client().send(request).timeout(const Duration(seconds: 15));
    if (response.statusCode != 200 && response.statusCode != 302) {
      throw Exception('Failed to update: ${response.statusCode}');
    }
  }

  static Future<void> submitApplication(Map<String, dynamic> data) async {
    try {
      final uri = Uri.parse(_baseUrl);
      
      // Google Apps Script drops the POST body when responding with 302 redirect.
      // We must disable followRedirects. A 302 is actually a SUCCESS for Apps Script POST.
      final request = http.Request('POST', uri)
        ..followRedirects = false
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          'type': 'add',
          ...data,
        });

      final response = await http.Client().send(request).timeout(const Duration(seconds: 20));
      
      // 200 or 302 means the script executed successfully
      if (response.statusCode != 200 && response.statusCode != 302) {
        throw Exception('Submission failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('SUBMIT ERROR: $e');
      throw Exception('Cloud sync failed: $e');
    }
  }
}
