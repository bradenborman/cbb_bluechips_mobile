import 'dart:async';

class AppUser {
  final String userId;
  final String displayName;
  final String email;
  final bool vip;

  const AppUser({
    required this.userId,
    required this.displayName,
    required this.email,
    required this.vip,
  });

  factory AppUser.fromJson(Map<String, dynamic> j) {
    final first = (j['firstName'] as String?)?.trim() ?? '';
    final last = (j['lastName'] as String?)?.trim() ?? '';
    final name = (first.isEmpty && last.isEmpty)
        ? (j['email'] as String? ?? '')
        : [first, last].where((s) => s.isNotEmpty).join(' ');
    return AppUser(
      userId: j['userId'] as String? ?? '',
      displayName: name,
      email: j['email'] as String? ?? '',
      vip: j['vip'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'displayName': displayName,
    'email': email,
    'vip': vip,
  };
}

abstract class IAuthRepository {
  AppUser? get currentUser;
  Stream<AppUser?> get onAuthStateChanged;

  Future<AppUser> signIn(String email, String password);
  Future<AppUser> createAccount({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  });

  Future<void> signOut();
  void dispose();
}