import 'package:http/http.dart' as http;

import '../api_config.dart';
import '../http_client.dart';
import 'package:cbb_bluechips_mobile/models/market.dart';
import 'package:cbb_bluechips_mobile/models/models.dart' show decodeJson;

class MarketService {
  const MarketService();

  Future<MarketResponse> getMarket({String? userId}) async {
    final uid = userId ?? ApiConfig.devUserId;
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