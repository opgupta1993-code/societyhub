import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://bahikhata.webenhancehub.com/api/v1';

  static Map<String, String> _headers([String? token]) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
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
