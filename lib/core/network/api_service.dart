import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  /// Base Root URL of SocietyHub backend
  static const String rootUrl = 'https://bahikhata.webenhancehub.com/societyhub/';

  /// Base API URL for endpoints (auth, complaints, bookings, bills)
  static const String baseUrl = 'https://bahikhata.webenhancehub.com/societyhub/api/v1';

  static const String defaultBearerToken =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2JhaGlraGF0YS53ZWJlbmhhbmNlaHViLmNvbS9zb2NpZXR5aHViLyIsImF1ZCI6Imh0dHBzOi8vYmFoaWtoYXRhLndlYmVuaGFuY2VodWIuY29tL3NvY2lldHlodWIvIiwiaWF0IjoxNzkxODkxNzA3LCJleHAiOjE3OTE5NzgxMDcsImRhdGEiOnsidWlkIjoidXNyXzc1NDMiLCJuYW1lIjoiT3duZXIgODUiLCJwaG9uZSI6Iis5MTgxMDk5NTc2NzIiLCJyb2xlIjoib3duZXIiLCJyb2xlX2lkIjoiMSIsInNob3BfaWQiOiJzaG9wX2tyaXNoYW5fOTkxIn19.BaBH8buFSa0VGcMgIEpGnVKLKgLZWlzR4zBJ9Zk1A38';

  static Map<String, String> _headers([String? token]) {
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

  /// POST /register or /auth/register
  static Future<Map<String, dynamic>> registerUser({
    required String name,
    required String phone,
    required String society,
    required String flat,
    required bool isOwner,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    final phoneToSend = _cleanPhone(phone);
    try {
      final response = await http.post(
        url,
        headers: _headers(),
        body: {
          'name': name,
          'ownerName': name,
          'phone': phoneToSend,
          'society': society,
          'shopName': society,
          'flat': flat,
          'address': flat,
          'is_owner': isOwner.toString(),
          'userType': isOwner ? 'owner' : 'tenant',
        },
      ).timeout(const Duration(seconds: 8));

      final data = jsonDecode(response.body);
      return data as Map<String, dynamic>;
    } catch (e) {
      return {
        'success': false,
        'message': 'Network timeout or connection error.',
      };
    }
  }
}
