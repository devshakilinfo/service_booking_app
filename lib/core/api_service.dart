import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class ApiService {
  static String baseUrl = AppConstants.defaultBaseUrl;

  static void setCustomBaseUrl(String url) {
    baseUrl = url;
  }

  static Future<Map<String, String>> _getHeaders({bool requireAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  static Future<dynamic> get(String endpoint, {bool requireAuth = false, Map<String, String>? queryParams}) async {
    try {
      var uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      throw 'Cannot reach backend server. Please check server status or connection IP.';
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, bool requireAuth = false}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http
          .post(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      throw 'Cannot reach backend server. Please check server status or connection IP.';
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, bool requireAuth = false}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http
          .put(uri, headers: headers, body: body != null ? jsonEncode(body) : null)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      throw 'Cannot reach backend server. Please check server status or connection IP.';
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> delete(String endpoint, {bool requireAuth = false}) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http
          .delete(uri, headers: headers)
          .timeout(const Duration(seconds: 15));

      return _handleResponse(response);
    } on SocketException {
      throw 'Cannot reach backend server. Please check server status or connection IP.';
    } catch (e) {
      rethrow;
    }
  }

  static dynamic _handleResponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      } else {
        final errorMsg = decoded['message'] ?? 'An error occurred (${response.statusCode})';
        throw errorMsg;
      }
    } catch (e) {
      if (e is String) rethrow;
      throw 'Failed to parse response (${response.statusCode})';
    }
  }
}
