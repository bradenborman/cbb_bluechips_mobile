import 'package:flutter/material.dart';

/// Server returns providers like "google" | "credentials".
enum SignInProvider { google, credentials }

extension SignInProviderApi on SignInProvider {
  static SignInProvider fromJson(String s) {
    switch (s) {
      case 'google':
        return SignInProvider.google;
      case 'credentials':
      default:
        return SignInProvider.credentials;
    }
  }

  String toJson() => this == SignInProvider.google ? 'google' : 'credentials';
}

/// Server returns displayNameStrategy: "FULL" | "FIRST_ABBREVIATED" | "LAST_ABBREVIATED".
enum DisplayNameStrategy { full, firstAbbreviated, lastAbbreviated }

extension DisplayNameStrategyApi on DisplayNameStrategy {
  static DisplayNameStrategy fromJson(String s) {
    switch (s) {
      case 'FIRST_ABBREVIATED':
        return DisplayNameStrategy.firstAbbreviated;
      case 'LAST_ABBREVIATED':
        return DisplayNameStrategy.lastAbbreviated;
      case 'FULL':
      default:
        return DisplayNameStrategy.full;
    }
  }

  String toJson() {
    switch (this) {
      case DisplayNameStrategy.firstAbbreviated:
        return 'FIRST_ABBREVIATED';
      case DisplayNameStrategy.lastAbbreviated:
        return 'LAST_ABBREVIATED';
      case DisplayNameStrategy.full:
        return 'FULL';
    }
  }
}

/// Server returns theme: "LIGHT" | "DARK" | "SYSTEM".
enum AppTheme { light, dark, system }

extension AppThemeApi on AppTheme {
  static AppTheme fromJson(String s) {
    switch (s) {
      case 'LIGHT':
        return AppTheme.light;
      case 'DARK':
        return AppTheme.dark;
      case 'SYSTEM':
      default:
        return AppTheme.system;
    }
  }

  String toJson() {
    switch (this) {
      case AppTheme.light:
        return 'LIGHT';
      case AppTheme.dark:
        return 'DARK';
      case AppTheme.system:
        return 'SYSTEM';
    }
  }
}

@immutable
class UserAccount {
  final String userId;
  final String email;
  final String userRole;
  final String firstName;
  final String lastName;
  final DisplayNameStrategy displayNameStrategy;
  final AppTheme theme;
  final bool subscribedToHelp;
  final bool vip;
  final List<SignInProvider> providers;
  final int? lastSignInAt;

  // Not in the API (optional; keeps your UI happy if you add avatars later)
  final String? imageUrl;

  const UserAccount({
    required this.userId,
    required this.email,
    required this.userRole,
    required this.firstName,
    required this.lastName,
    required this.displayNameStrategy,
    required this.theme,
    required this.subscribedToHelp,
    required this.vip,
    required this.providers,
    this.lastSignInAt,
    this.imageUrl,
  });

  String get displayName {
    switch (displayNameStrategy) {
      case DisplayNameStrategy.full:
        return '$firstName $lastName'.trim();
      case DisplayNameStrategy.firstAbbreviated:
        final fi = firstName.isNotEmpty ? '${firstName[0]}.' : '';
        return [fi, lastName].where((s) => s.isNotEmpty).join(' ').trim();
      case DisplayNameStrategy.lastAbbreviated:
        final li = lastName.isNotEmpty ? '${lastName[0]}.' : '';
        return [firstName, li].where((s) => s.isNotEmpty).join(' ').trim();
    }
  }

  UserAccount copyWith({
    String? userId,
    String? email,
    String? userRole,
    String? firstName,
    String? lastName,
    DisplayNameStrategy? displayNameStrategy,
    AppTheme? theme,
    bool? subscribedToHelp,
    bool? vip,
    List<SignInProvider>? providers,
    int? lastSignInAt,
    String? imageUrl,
  }) {
    return UserAccount(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      userRole: userRole ?? this.userRole,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      displayNameStrategy: displayNameStrategy ?? this.displayNameStrategy,
      theme: theme ?? this.theme,
      subscribedToHelp: subscribedToHelp ?? this.subscribedToHelp,
      vip: vip ?? this.vip,
      providers: providers ?? this.providers,
      lastSignInAt: lastSignInAt ?? this.lastSignInAt,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    final prov = (json['providers'] as List? ?? [])
        .map((e) => SignInProviderApi.fromJson('$e'))
        .toList();
    return UserAccount(
      userId: json['userId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      userRole: json['userRole'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      displayNameStrategy: DisplayNameStrategyApi.fromJson(
        json['displayNameStrategy'] as String? ?? 'FULL',
      ),
      theme: AppThemeApi.fromJson(json['theme'] as String? ?? 'SYSTEM'),
      subscribedToHelp: json['subscribedToHelp'] as bool? ?? false,
      vip: json['vip'] as bool? ?? false,
      providers: prov,
      lastSignInAt: json['lastSignInAt'] as int?,
      imageUrl: null,
    );
  }

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'email': email,
    'userRole': userRole,
    'firstName': firstName,
    'lastName': lastName,
    'displayNameStrategy': displayNameStrategy.toJson(),
    'theme': theme.toJson(),
    'subscribedToHelp': subscribedToHelp,
    'vip': vip,
    'providers': providers.map((p) => p.toJson()).toList(),
    'lastSignInAt': lastSignInAt,
  };
}