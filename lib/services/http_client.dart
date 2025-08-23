//lib/services/http_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiHttp {
  ApiHttp._();

  static Map<String, String> _headers() {
    final auth = base64Encode(
      utf8.encode('${ApiConfig.apiUserUsername}:${ApiConfig.apiUserPassword}'),
    );
    return {
      'Authorization': 'Basic $auth',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
  }

  static Uri _u(String path, [Map<String, String>? q]) =>
      Uri.parse('${ApiConfig.baseUrl}$path').replace(queryParameters: q);

  static Future<http.Response> get(String path, {Map<String, String>? query}) {
    return http.get(_u(path, query), headers: _headers());
  }

  static Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? query,
  }) {
    return http.post(
      _u(path, query),
      headers: _headers(),
      body: body == null ? null : jsonEncode(body),
    );
  }
}
