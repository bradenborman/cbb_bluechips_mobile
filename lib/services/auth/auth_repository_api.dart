// lib/services/auth/auth_repository_api.dart
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../http_client.dart'; // <-- your ApiHttp
import 'auth_repository.dart';

class AuthRepositoryApi implements IAuthRepository {
  static const _prefsKey = 'cbb.auth.user';
  final _ctrl = StreamController<AppUser?>.broadcast();
  AppUser? _current;

  AuthRepositoryApi() {
    _restore();
  }

  @override
  AppUser? get currentUser => _current;

  @override
  Stream<AppUser?> get onAuthStateChanged => _ctrl.stream;

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        _current = AppUser.fromJson(j);
        _ctrl.add(_current);
      } catch (_) {}
    }
  }

  Future<void> _persist(AppUser? u) async {
    final prefs = await SharedPreferences.getInstance();
    if (u == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, jsonEncode(u.toJson()));
    }
  }

  AppUser _set(AppUser u) {
    _current = u;
    _ctrl.add(u);
    _persist(u);
    return u;
  }

  // ---------------------------
  // Sign In
  // ---------------------------
  @override
  Future<AppUser> signIn(String email, String password) async {
    const path = '/api/user/sign-in-with-credentials';
    final res = await ApiHttp.post(path, body: {
      'email': email,
      'password': password,
    }); // <-- pass Map, not jsonEncode

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return _set(AppUser.fromJson(j));
    }

    final msg = _composeServerMessage(
      path: path,
      status: res.statusCode,
      rawBody: res.body,
      fallback: 'Sign in failed (${res.statusCode}).',
    );

    if (res.statusCode == 401) {
      throw AuthError('invalid', 'Email or password is incorrect.');
    }
    if (res.statusCode == 403) {
      throw AuthError('banned', 'Your account has been restricted.');
    }
    if (res.statusCode == 400) {
      throw AuthError('bad_request', msg);
    }
    throw AuthError('error', msg);
  }

  // ---------------------------
  // Create Account
  // ---------------------------
  @override
  Future<AppUser> createAccount({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final local = email.split('@').first;
    final f = (firstName?.trim().isNotEmpty == true)
        ? firstName!.trim()
        : _title(_firstToken(local));
    final l = (lastName?.trim().isNotEmpty == true)
        ? lastName!.trim()
        : _title(_lastTokens(local));

    const path = '/api/user';
    final res = await ApiHttp.post(path, body: {
      'firstName': f,
      'lastName': l,
      'email': email,
      'password': password,
    }); // <-- pass Map, not jsonEncode

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return _set(AppUser.fromJson(j));
    }

    final msg = _composeServerMessage(
      path: path,
      status: res.statusCode,
      rawBody: res.body,
      fallback: 'Create account failed (${res.statusCode}).',
    );

    if (res.statusCode == 409) {
      throw AuthError('exists', 'An account already exists for this email.');
    }
    if (res.statusCode == 403) {
      throw AuthError('banned', 'Your account has been restricted.');
    }
    if (res.statusCode == 400) {
      // e.g. "Signup period is over" or validation failure
      throw AuthError('signup_closed', msg);
    }
    throw AuthError('error', msg);
  }

  // ---------------------------
  // Helpers
  // ---------------------------
  String _composeServerMessage({
    required String path,
    required int status,
    required String rawBody,
    required String fallback,
  }) {
    final trimmed = rawBody.trim();
    try {
      if (trimmed.isNotEmpty && trimmed.startsWith('{')) {
        final obj = jsonDecode(trimmed);
        if (obj is Map && obj['message'] is String && (obj['message'] as String).isNotEmpty) {
          return obj['message'] as String;
        }
        if (obj is Map && obj['error'] is String && (obj['error'] as String).isNotEmpty) {
          return obj['error'] as String;
        }
      }
    } catch (_) {}
    if (trimmed.isNotEmpty && !trimmed.startsWith('<')) return trimmed;
    // ignore: avoid_print
    print('Auth error $status @ $path\n$rawBody');
    return fallback;
  }

  String _firstToken(String s) {
    final p = s.split(RegExp(r'[._\s]+')).where((x) => x.isNotEmpty).toList();
    return p.isEmpty ? 'Player' : p.first;
  }

  String _lastTokens(String s) {
    final p = s.split(RegExp(r'[._\s]+')).where((x) => x.isNotEmpty).toList();
    if (p.length <= 1) return '';
    return p.sublist(1).join(' ');
  }

  String _title(String s) {
    if (s.isEmpty) return '';
    return s
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .map((p) => p[0].toUpperCase() + p.substring(1))
        .join(' ');
  }

  @override
  Future<void> signOut() async {
    _current = null;
    _ctrl.add(null);
    await _persist(null);
  }

  @override
  void dispose() {
    _ctrl.close();
  }
}

class AuthError implements Exception {
  final String code;
  final String message;
  const AuthError(this.code, this.message);
  @override
  String toString() => message;
}
