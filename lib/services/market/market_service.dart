import 'package:http/http.dart' as http;

import '../../services/http_client.dart';
import 'package:cbb_bluechips_mobile/models/market.dart';
import 'package:cbb_bluechips_mobile/models/models.dart' show decodeJson;
import 'package:cbb_bluechips_mobile/services/auth/auth_controller.dart';


class MarketService {
  final AuthController auth;

  const MarketService(this.auth);

  Future<MarketResponse> getMarket() async {
    final uid = auth.currentUser?.userId;
    if (uid == null || uid.isEmpty) {
      throw StateError('No userId available for market request.');
    }

    final http.Response res = await ApiHttp.get(
      '/api/market',
      query: {'userId': uid},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return MarketResponse.fromJson(decodeJson(res.body));
    }
    throw Exception('Market failed: ${res.statusCode}');
  }
}