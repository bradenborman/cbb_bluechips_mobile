import 'package:flutter/foundation.dart';
import 'auth_repository_mock.dart';

/// Controls the authentication state and bridges UI with the repository.
class AuthController extends ChangeNotifier {
  final AuthRepositoryMock _repo;

  AuthController(this._repo) {
    // Keep listening to repo changes
    _repo.onAuthStateChanged.listen((_) => notifyListeners());
  }

  bool get isAuthed => _repo.currentUser != null;
  MockUser? get currentUser => _repo.currentUser;

  Future<void> signInWithApple() async {
    await _repo.signInWithApple();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await _repo.signInWithGoogle();
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    await _repo.signInWithEmail(email, password);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _repo.signOut();
    notifyListeners();
  }

  @override
  void dispose() {
    _repo.dispose();
    super.dispose();
  }
}
