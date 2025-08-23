import 'package:flutter/foundation.dart';
import 'auth_repository.dart';

class AuthController extends ChangeNotifier {
  final IAuthRepository _repo;

  AuthController(this._repo) {
    _repo.onAuthStateChanged.listen((_) => notifyListeners());
  }

  bool get isAuthed => _repo.currentUser != null;
  AppUser? get currentUser => _repo.currentUser;

  Future<void> signIn(String email, String password) async {
    await _repo.signIn(email, password);
    notifyListeners();
  }

  Future<void> createAccount(
    String email,
    String password, {
    String? firstName,
    String? lastName,
  }) async {
    await _repo.createAccount(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repo.signOut();
    notifyListeners();
  }

  // SSO later:
  Future<void> signInWithApple() async =>
      throw UnimplementedError('Apple SSO later');

  Future<void> signInWithGoogle() async =>
      throw UnimplementedError('Google SSO later');

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}