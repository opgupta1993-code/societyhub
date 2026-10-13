import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// Base Root URL of SocietyHub backend
  static const String rootUrl = 'https://bahikhata.webenhancehub.com/societyhub/';

  /// Base API URL for endpoints (auth, complaints, bookings, bills)
  static const String baseUrl = 'https://bahikhata.webenhancehub.com/societyhub/api/v1';

  static const String defaultBearerToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2JhaGlraGF0YS53ZWJlbmhhbmNlaHViLmNvbS9zb2NpZXR5aHViLyIsImF1ZCI6Imh0dHBzOi8vYmFoaWtoYXRhLndlYmVuaGFuY2VodWIuY29tL3NvY2lldHlodWIvIiwiaWF0IjoxNzkxODkxNzA3LCJleHAiOjE3OTE5NzgxMDcsImRhdGEiOnsidWlkIjoidXNyXzc1NDMiLCJuYW1lIjoiT3duZXIgODUiLCJwaG9uZSI6Iis5MTgxMDk5NTc2NzIiLCJyb2xlIjoib3duZXIiLCJyb2xlX2lkIjoiMSIsInNob3BfaWQiOiJzaG9wX2tyaXNoYW5fOTkxIn19.BaBH8buFSa0VGcMgIEpGnVKLKgLZWlzR4zBJ9Zk1A38';

  static Map<String, String> authHeaders([String? token]) {
    final authToken = (token != null && token.isNotEmpty) ? token : defaultBearerToken;
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer $authToken',
    };
  }

  static Map<String, String> _publicHeaders() {
    return {
      'Accept': 'application/json',
    };
  }

  static String _cleanPhone(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 12 && digits.startsWith('91')) {
      return digits.substring(2);
    }
    return digits.isNotEmpty ? digits : raw;
  }

  /// POST /auth/request-otp
  static Future<Map<String, dynamic>> requestOtp(String phone) async {
    final url = Uri.parse('$baseUrl/auth/request-otp');
    final phoneToSend = _cleanPhone(phone);
    try {
      final response = await http.post(
        url,
        headers: _publicHeaders(),
        body: {'phone': phoneToSend},
      ).timeout(const Duration(seconds: 8));

      try {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return data as Map<String, dynamic>;
        } else {
          return {
            'success': false,
            'message': (data is Map && data['message'] != null)
                ? data['message']
                : 'Server returned ${response.statusCode}',
          };
        }
      } catch (_) {
        return {
          'success': false,
          'message': 'Unexpected server response (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection timed out. Please try again.',
      };
    }
  }

  /// POST /auth/verify-otp
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) async {
    final url = Uri.parse('$baseUrl/auth/verify-otp');
    final phoneToSend = _cleanPhone(phone);
    try {
      final response = await http.post(
        url,
        headers: _publicHeaders(),
        body: {
          'phone': phoneToSend,
          'otp': otp,
        },
      ).timeout(const Duration(seconds: 8));

      try {
        final data = jsonDecode(response.body);
        if (response.statusCode == 200 || response.statusCode == 201) {
          return data as Map<String, dynamic>;
        } else {
          return {
            'success': false,
            'message': (data is Map && data['message'] != null)
                ? data['message']
                : 'Invalid OTP code',
          };
        }
      } catch (_) {
        return {
          'success': false,
          'message': 'Unexpected server response (${response.statusCode})',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection timed out. Please try again.',
      };
    }
  }

  /// POST /auth/register (or /register)
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    String? email,
    required String society,
    String? tower,
    required String flat,
    required bool isOwner,
  }) async {
    final phoneToSend = _cleanPhone(phone);
    final blockFlat = (tower != null && tower.isNotEmpty) ? 'Tower $tower - $flat' : flat;

    final bodyData = {
      'name': name,
      'full_name': name,
      'phone': phoneToSend,
      'mobile_number': phoneToSend,
      if (email != null && email.isNotEmpty) 'email': email,
      'society': society,
      'society_name': society,
      if (tower != null && tower.isNotEmpty) 'tower': tower,
      'flat': flat,
      'block_flat': blockFlat,
      'is_owner': isOwner ? '1' : '0',
      'role_id': isOwner ? '1' : '3',
      'role': isOwner ? 'owner' : 'resident',
    };

    try {
      final url = Uri.parse('$baseUrl/auth/register');
      final response = await http.post(
        url,
        headers: _publicHeaders(),
        body: bodyData,
      ).timeout(const Duration(seconds: 10));

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return data as Map<String, dynamic>;
      } else {
        // If 404, try fallback endpoint /register
        if (response.statusCode == 404) {
          final fallbackUrl = Uri.parse('$baseUrl/register');
          final fallbackRes = await http.post(
            fallbackUrl,
            headers: _publicHeaders(),
            body: bodyData,
          ).timeout(const Duration(seconds: 10));
          return jsonDecode(fallbackRes.body) as Map<String, dynamic>;
        }
        return (data is Map<String, dynamic>) ? data : {'success': false, 'message': 'Registration error'};
      }
    } catch (_) {
      try {
        final fallbackUrl = Uri.parse('$baseUrl/register');
        final response = await http.post(
          fallbackUrl,
          headers: _publicHeaders(),
          body: bodyData,
        ).timeout(const Duration(seconds: 10));
        return jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        return {
          'success': false,
          'message': 'Network timeout or connection error.',
        };
      }
    }
  }
}
