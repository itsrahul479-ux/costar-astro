import 'dart:convert';
import 'package:http/http.dart' as http;

/// Central HTTP client for all API calls to the Astro backend.
/// Automatically attaches auth token and handles errors gracefully.
class ApiClient {
  // Base URL — change to your deployed URL for production
  static const String baseUrl = 'http://localhost:8000/api/v1';

  String? _authToken;

  // Singleton
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  void setToken(String token) {
    _authToken = token;
  }

  void clearToken() {
    _authToken = null;
  }

  bool get isAuthenticated => _authToken != null;

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // --- Generic request methods ---

  Future<Map<String, dynamic>?> get(String path) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl$path'), headers: _headers)
          .timeout(const Duration(seconds: 15));
      return _parseResponse(res);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> post(String path, Map<String, dynamic> body) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl$path'),
            headers: _headers,
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 20));
      return _parseResponse(res);
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  Map<String, dynamic>? _parseResponse(http.Response res) {
    try {
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      return body;
    } catch (_) {
      return {'success': false, 'error': 'Invalid response from server'};
    }
  }
}
