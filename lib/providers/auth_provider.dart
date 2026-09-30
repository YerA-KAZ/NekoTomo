import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/models/user.dart';
import 'package:nekotomo_app/services/api_service.dart';
import 'package:nekotomo_app/services/storage_service.dart';

/// Auth state
class AuthState {
  final User? user;
  final bool isLoading;
  final bool isLoggedIn;
  final String? error;

  AuthState({
    this.user,
    this.isLoading = false,
    this.isLoggedIn = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    bool? isLoading,
    bool? isLoggedIn,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  AuthNotifier() : super(AuthState());

  /// Check if user is already logged in
  Future<bool> checkAuth() async {
    final hasToken = await _storage.hasToken();
    if (!hasToken) return false;

    try {
      state = state.copyWith(isLoading: true);
      final response = await _api.getMe();
      final user = User.fromJson(response.data);
      state = AuthState(user: user, isLoggedIn: true);
      return true;
    } catch (e) {
      await _storage.clearToken();
      state = AuthState();
      return false;
    }
  }

  /// Register new user
  Future<bool> register(String username, String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.register(username, email, password);
      final data = response.data;

      await _storage.saveToken(data['token']);
      await _storage.saveUsername(data['user']['username']);

      final user = User.fromJson(data['user']);
      state = AuthState(user: user, isLoggedIn: true);
      return true;
    } catch (e) {
      final message = _extractError(e);
      state = state.copyWith(isLoading: false, error: message);
      return false;
    }
  }

  /// Login
  Future<bool> login(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.login(email, password);
      final data = response.data;

      await _storage.saveToken(data['token']);
      await _storage.saveUsername(data['user']['username']);

      final user = User.fromJson(data['user']);
      state = AuthState(user: user, isLoggedIn: true);
      return true;
    } catch (e) {
      final message = _extractError(e);
      state = state.copyWith(isLoading: false, error: message);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _storage.clearToken();
    state = AuthState();
  }

  String _extractError(dynamic e) {
    if (e is Exception) {
      try {
        final dioError = e as dynamic;
        return dioError.response?.data?['error'] ?? 'Connection problem. Please try again.';
      } catch (_) {}
    }
    return 'Connection problem. Please try again.';
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
