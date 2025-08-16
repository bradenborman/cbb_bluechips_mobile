import 'dart:async';

/// Represents a fake signed-in user.
class MockUser {
  final String id;
  final String email;
  final String provider; // "apple", "google", "email"

  const MockUser({
    required this.id,
    required this.email,
    required this.provider,
  });
}

/// A mock repository that pretends to handle login/logout.
/// No network calls — all local memory with timers.
class AuthRepositoryMock {
  MockUser? _currentUser;
  DateTime? _expiry;
  final _controller = StreamController<MockUser?>.broadcast();

  Stream<MockUser?> get onAuthStateChanged => _controller.stream;

  MockUser? get currentUser {
    if (_expiry != null && DateTime.now().isBefore(_expiry!)) {
      return _currentUser;
    }
    return null;
  }

  /// Fake Apple sign in
  Future<void> signInWithApple() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _setUser(
      const MockUser(
        id: "apple123",
        email: "appleuser@mock.com",
        provider: "apple",
      ),
    );
  }

  /// Fake Google sign in
  Future<void> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 600));
    _setUser(
      const MockUser(
        id: "google123",
        email: "googleuser@mock.com",
        provider: "google",
      ),
    );
  }

  /// Fake Email sign in
  Future<void> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _setUser(MockUser(id: "email123", email: email, provider: "email"));
  }

  /// Logs out and clears the user
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _expiry = null;
    _controller.add(null);
  }

  void _setUser(MockUser user) {
    _currentUser = user;
    _expiry = DateTime.now().add(const Duration(hours: 8)); // session lifetime
    _controller.add(user);
  }

  void dispose() {
    _controller.close();
  }
}
