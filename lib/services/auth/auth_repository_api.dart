// lib/services/auth/auth_repository_api.dart
import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../http_client.dart'; // <-- your ApiHttp (auth headers already handled)
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

  // ---------------------------
  // Bootstrap persistence
  // ---------------------------
  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      try {
        final j = jsonDecode(raw) as Map<String, dynamic>;
        _current = AppUser.fromJson(j);
        _ctrl.add(_current);
      } catch (_) {
        // ignore malformed cache
      }
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
    // fire and forget
    _persist(u);
    return u;
  }

  // ---------------------------
  // Email/Password
  // ---------------------------
  @override
  Future<AppUser> signIn(String email, String password) async {
    const path = '/api/user/sign-in-with-credentials';
    final res = await ApiHttp.post(
      path,
      body: {'email': email, 'password': password},
    ); // Map body (client encodes)

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
      throw const AuthError('invalid', 'Email or password is incorrect.');
    }
    if (res.statusCode == 403) {
      throw const AuthError('banned', 'Your account has been restricted.');
    }
    if (res.statusCode == 400) {
      throw AuthError('bad_request', msg);
    }
    throw AuthError('error', msg);
  }

  @override
  Future<AppUser> createAccount({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    // Basic defaults like you had before
    final local = email.split('@').first;
    final f = (firstName?.trim().isNotEmpty == true)
        ? firstName!.trim()
        : _title(_firstToken(local));
    final l = (lastName?.trim().isNotEmpty == true)
        ? lastName!.trim()
        : _title(_lastTokens(local));

    const path = '/api/user';
    final res = await ApiHttp.post(
      path,
      body: {
        'firstName': f,
        'lastName': l,
        'email': email,
        'password': password,
      },
    );

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
      throw const AuthError(
        'exists',
        'An account already exists for this email.',
      );
    }
    if (res.statusCode == 403) {
      throw const AuthError('banned', 'Your account has been restricted.');
    }
    if (res.statusCode == 400) {
      throw AuthError('signup_closed', msg);
    }
    throw AuthError('error', msg);
  }

  // ---------------------------
  // Google SSO (device flow)
  // ---------------------------
  @override
  Future<AppUser> signInWithGoogleDevice() async {
    // Create a GoogleSignIn instance with your iOS client ID.
    // (Safe to use on iOS Simulator & devices.)
    final google = GoogleSignIn(
      clientId:
          '646077869401-qeua40l97a1412au4utla3s3jsog148c.apps.googleusercontent.com',
      scopes: const ['email', 'profile', 'openid'],
    );

    // 1) Launch Google account picker
    final account = await google.signIn();
    if (account == null) {
      throw const AuthError('canceled', 'Google sign-in canceled.');
    }

    // 2) Grab tokens
    final auth = await account.authentication;
    final idToken = auth.idToken; // JWT from Google
    // We’ll also derive the "sub" (Google user id) to match your backend contract
    final googleId = (idToken != null) ? _readIdTokenSub(idToken) : null;

    if (googleId == null || googleId.isEmpty) {
      // Fallback: some older configs may not yield idToken on simulators.
      // We still send email/displayName in case your API accepts that.
      // But in general, Google ID from "sub" is preferred.
      // If you want to hard-require it, you can throw here.
    }

    // 3) Call your API
    // Your earlier plan: server expects Google ID (sub) and will return user JSON.
    const path = '/api/user/sign-in-with-google';
    final res = await ApiHttp.post(
      path,
      body: {
        // Provide both for flexibility server-side:
        'googleId': googleId ?? '',
        'idToken': idToken ?? '',
        'email': account.email,
        'name': account.displayName ?? '',
        // add more fields if your API doc specifies (e.g., avatarUrl)
      },
    );

    if (res.statusCode == 200) {
      final j = jsonDecode(res.body) as Map<String, dynamic>;
      return _set(AppUser.fromJson(j));
    }

    final msg = _composeServerMessage(
      path: path,
      status: res.statusCode,
      rawBody: res.body,
      fallback: 'Google sign-in failed (${res.statusCode}).',
    );

    if (res.statusCode == 401) {
      throw const AuthError('unauthorized', 'Google sign-in unauthorized.');
    }
    if (res.statusCode == 400) {
      throw AuthError('bad_request', msg);
    }
    throw AuthError('error', msg);
  }

  // ---------------------------
  // Sign out
  // ---------------------------
  @override
  Future<void> signOut() async {
    _current = null;
    _ctrl.add(null);
    await _persist(null);
    // Optional: also sign out of Google on device:
    try {
      final google = GoogleSignIn(
        clientId:
            '646077869401-qeua40l97a1412au4utla3s3jsog148c.apps.googleusercontent.com',
      );
      await google.signOut();
    } catch (_) {
      /* ignore */
    }
  }

  @override
  void dispose() {
    _ctrl.close();
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
        if (obj is Map &&
            obj['message'] is String &&
            (obj['message'] as String).isNotEmpty) {
          return obj['message'] as String;
        }
        if (obj is Map &&
            obj['error'] is String &&
            (obj['error'] as String).isNotEmpty) {
          return obj['error'] as String;
        }
      }
    } catch (_) {}
    if (trimmed.isNotEmpty && !trimmed.startsWith('<')) return trimmed;
    // ignore: avoid_print
    print('Auth error $status @ $path\n$rawBody');
    return fallback;
  }

  String? _readIdTokenSub(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length != 3) return null;
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final claims = jsonDecode(payload) as Map<String, dynamic>;
      final sub = claims['sub'] as String?;
      return (sub == null || sub.isEmpty) ? null : sub;
    } catch (_) {
      return null;
    }
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
}

class AuthError implements Exception {
  final String code;
  final String message;
  const AuthError(this.code, this.message);
  @override
  String toString() => message;
}