import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';

// ─── Auth State ──────────────────────────────────────────────
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? name;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.userId,
    this.email,
    this.name,
    this.error,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? name,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      error: error,
    );
  }
}

// ─── Auth Notifier ────────────────────────────────────────────
class AuthNotifier extends StateNotifier<AuthState> {
  final ApiClient _api = ApiClient();

  AuthNotifier() : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getString('user_id');
    final name = prefs.getString('user_name');
    final email = prefs.getString('user_email');

    if (token != null && userId != null) {
      _api.setToken(token);
      state = state.copyWith(
        isAuthenticated: true,
        userId: userId,
        name: name,
        email: email,
      );
    }
  }

  Future<bool> signup({required String email, required String password, required String name}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _api.post('/auth/signup', {
      'email': email,
      'password': password,
      'name': name,
    });

    return _handleAuthResult(result);
  }

  Future<bool> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _api.post('/auth/login', {
      'email': email,
      'password': password,
    });

    return _handleAuthResult(result);
  }

  Future<bool> _handleAuthResult(Map<String, dynamic>? result) async {
    if (result == null || result['success'] != true) {
      state = state.copyWith(
        isLoading: false,
        error: result?['error'] ?? result?['detail'] ?? 'Authentication failed',
      );
      return false;
    }

    final data = result['data'] as Map<String, dynamic>;
    final token = data['access_token'] as String;
    final user = data['user'] as Map<String, dynamic>;

    _api.setToken(token);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_id', user['id'] as String);
    await prefs.setString('user_name', user['name'] as String? ?? '');
    await prefs.setString('user_email', user['email'] as String);

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      userId: user['id'] as String,
      name: user['name'] as String?,
      email: user['email'] as String,
      error: null,
    );
    return true;
  }

  Future<void> logout() async {
    _api.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_email');
    state = const AuthState();
  }
}

// ─── Providers ───────────────────────────────────────────────
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);
