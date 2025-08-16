import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_models.dart';
import 'auth_repository_mock.dart';

/// Holds current session and persists it locally.
/// Swap AuthRepositoryMock with a real repo later without touching UI.
class AuthController extends ChangeNotifier {
  static const _prefsKey = 'cbb_auth_session_v1';

  final AuthRepositoryMock _repo;
  AuthSession? _session;

  AuthController(this._repo);

  AuthSession? get session => _session;
  bool get isAuthed => _session != null && !_session!.isExpired;

  /// Load a previously saved session.
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) return;
    try {
      final map = jsonDecode(raw) as Map<String, Object?>;
      final restored = AuthSession.fromJson(map);
      if (restored != null && !restored.isExpired) {
        _session = restored;
        notifyListeners();
      } else {
        await prefs.remove(_prefsKey);
      }
    } catch (_) {
      await prefs.remove(_prefsKey);
    }
  }

  Future<void> signIn(String email, String password) async {
    final s = await _repo.signIn(email: email, password: password);
    _session = s;
    await _persist();
    notifyListeners();
  }

  Future<void> signInWithApple() async {
    final s = await _repo.signInWithApple();
    _session = s;
    await _persist();
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repo.signOut();
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, jsonEncode(_session!.toJson()));
  }
}
