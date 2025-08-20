import 'package:flutter/material.dart';

enum SignInProvider { credentials, google }

enum DisplayNameStrategy {
  firstLast,
  firstLastInitial,
  handleOnly,
}

@immutable
class UserAccount {
  final String firstName;
  final String lastName;
  final String email;
  final String? imageUrl;
  final List<SignInProvider> providers;
  final DisplayNameStrategy displayNameStrategy;

  const UserAccount({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.providers,
    this.imageUrl,
    this.displayNameStrategy = DisplayNameStrategy.firstLast,
  });

  String get displayName {
    switch (displayNameStrategy) {
      case DisplayNameStrategy.firstLast:
        return '$firstName $lastName';
      case DisplayNameStrategy.firstLastInitial:
        final initial = lastName.isNotEmpty ? '${lastName[0]}.' : '';
        return '$firstName $initial';
      case DisplayNameStrategy.handleOnly:
        return '@${firstName.toLowerCase()}';
    }
  }

  UserAccount copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? imageUrl,
    List<SignInProvider>? providers,
    DisplayNameStrategy? displayNameStrategy,
  }) {
    return UserAccount(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      providers: providers ?? this.providers,
      displayNameStrategy: displayNameStrategy ?? this.displayNameStrategy,
    );
  }
}
