import 'package:flutter/foundation.dart';

@immutable
class AuthSession {
  final String accessToken;
  final DateTime expiresAt;
  final String userId;
  final String displayName;

  const AuthSession({
    required this.accessToken,
    required this.expiresAt,
    required this.userId,
    required this.displayName,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, Object?> toJson() => {
    'accessToken': accessToken,
    'expiresAt': expiresAt.millisecondsSinceEpoch,
    'userId': userId,
    'displayName': displayName,
  };

  static AuthSession? fromJson(Map<String, Object?>? json) {
    if (json == null) return null;
    final ts = json['expiresAt'];
    if (ts is! int) return null;
    return AuthSession(
      accessToken: json['accessToken'] as String? ?? '',
      expiresAt: DateTime.fromMillisecondsSinceEpoch(ts),
      userId: json['userId'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
    );
  }
}