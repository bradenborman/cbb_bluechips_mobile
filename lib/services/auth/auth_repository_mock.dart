import 'dart:async';
import 'dart:math';
import 'auth_models.dart';

/// 100% offline mock auth. Accepts any email/password.
/// Also stubs "Sign in with Apple".
class AuthRepositoryMock {
  const AuthRepositoryMock();

  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    // Simulate "network"
    await Future.delayed(const Duration(milliseconds: 550));

    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required');
    }

    final name = _deriveDisplayName(email);
    final token = _fakeJwt();
    final uid = 'user_${_hash(email)}';

    return AuthSession(
      accessToken: token,
      // 8 hours for demo
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
      userId: uid,
      displayName: name,
    );
  }

  /// Stub: Sign in with Apple (no network). Returns a mock session.
  Future<AuthSession> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 450));
    return AuthSession(
      accessToken: _fakeJwt(),
      expiresAt: DateTime.now().add(const Duration(hours: 8)),
      userId: 'apple_${Random().nextInt(1 << 20)}',
      displayName: 'Apple User',
    );
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 150));
  }

  String _deriveDisplayName(String email) {
    final base = email.split('@').first.trim();
    if (base.isEmpty) return 'Player';
    return base
        .split(RegExp(r'[._\\- ]+'))
        .map((p) {
          if (p.isEmpty) return p;
          final head = p[0].toUpperCase();
          final tail = p.length > 1 ? p.substring(1) : '';
          return '$head$tail';
        })
        .join(' ');
  }

  String _fakeJwt() {
    final r = Random();
    final body = List.generate(
      24,
      (_) => r.nextInt(36),
    ).map((i) => i.toRadixString(36)).join();
    return 'mock.$body.token';
  }

  int _hash(String s) =>
      s.codeUnits.fold(0, (a, b) => (a * 31 + b) & 0x7fffffff);
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
