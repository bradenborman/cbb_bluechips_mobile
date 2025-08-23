/// Central config for calling the CBB Blue Chips API.
///
/// You can override the username/password at build time with:
/// flutter run -d ios --dart-define=API_USER_USERNAME=... --dart-define=API_USER_PASSWORD=...
///
/// For now we hardcode your test creds so it "just works".
class ApiConfig {
  static const String baseUrl = 'https://cbb-bluechips-api-production.up.railway.app';

  // Name them like you suggested.
  static const String apiUserUsername = String.fromEnvironment(
    'API_USER_USERNAME',
    defaultValue: 'user_3S29xwzHoigCE7bJ8zvg',
  );

  static const String apiUserPassword = String.fromEnvironment(
    'API_USER_PASSWORD',
    defaultValue: 'pw_ZZ1ZP8wj0FWy1pvLbSamEzPwmOTwg4M0vJ1nmnMX',
  );
  
}