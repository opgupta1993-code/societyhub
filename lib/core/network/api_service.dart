import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bahikhata.webenhancehub.com/api/v1';

  static const String defaultBearerToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2JhaGlraGF0YS53ZWJlbmhhbmNlaHViLmNvbS8iLCJhdWQiOiJodHRwczovL2JhaGlraGF0YS53ZWJlbmhhbmNlaHViLmNvbS8iLCJpYXQiOjE3OTEyNzY4MjksImV4cCI6MTc5MTM2MzIyOSwiZGF0YSI6eyJ1aWQiOiJ1c3JfNzU0MyIsIm5hbWUiOiJPd25lciA4NSIsInBob25lIjoiKzkxODEwOTk1NzY3MiIsInJvbGUiOiJvd25lciIsInNob3BfaWQiOiJzaG9wX2tyaXNoYW5fOTkxIn19.S4yj9WyTIJtyJAf_-fw3CRPbgDlCRatj0YMfyYyTLDY';

  static Map<String, String> _headers([String? token]) {
    final authToken = (token != null && token.isNotEmpty) ? token : defaultBearerToken;
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  /// POST /auth/request-otp
  static Future<Map<String, dynamic>> requestOtp(String phone) async {
    final url = Uri.parse('$baseUrl/auth/request-otp');
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode({'phone': phone}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data as Map<String, dynamic>;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to send OTP (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// POST /auth/verify-otp
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp');
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data as Map<String, dynamic>;
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Invalid OTP code',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  /// POST /auth/register
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    required String society,
    required String flat,
    required bool isOwner,
  }) async {
    final url = Uri.parse('$baseUrl/auth/register');
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'society': society,
          'flat': flat,
          'is_owner': isOwner,
        }),
      );
      final data = jsonDecode(response.body);
      return data as Map<String, dynamic>;
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }
}
