import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool isGuest;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.isGuest = false,
  });

  AuthState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? isGuest,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isGuest: isGuest ?? this.isGuest,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _initUser();
  }

  void _initUser() {
    // Default demo guest session so user can immediately test the app
    state = const AuthState(
      user: UserModel(
        id: 'guest_user_123',
        email: 'user@finflow.app',
        displayName: 'Akun FinFlow Demo',
      ),
      isGuest: true,
    );
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800)); // Simulasi network

    if (email.isNotEmpty && password.length >= 6) {
      state = AuthState(
        user: UserModel(
          id: 'user_${email.hashCode}',
          email: email,
          displayName: email.split('@').first,
        ),
        isLoading: false,
        isGuest: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email atau password minimal 6 karakter.',
      );
      return false;
    }
  }

  Future<void> logout() async {
    state = const AuthState(user: null, isGuest: false);
  }

  void continueAsGuest() {
    state = const AuthState(
      user: UserModel(
        id: 'guest_user_123',
        email: 'tamu@finflow.app',
        displayName: 'Pengguna Tamu',
      ),
      isGuest: true,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
