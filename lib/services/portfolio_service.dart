import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'api_config.dart';
import 'http_client.dart';

class PortfolioService {
  const PortfolioService();

  Future<Portfolio> getOverview({String? userId}) async {
    final uid = userId ?? ApiConfig.devUserId;
    final http.Response res = await ApiHttp.get(
      '/api/portfolio/overview',
      query: {'userId': uid},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Portfolio.fromJson(decodeJson(res.body));
    }
    throw Exception('Overview failed: ${res.statusCode}');
  }

  Future<PortfolioResponse> getInvestments({String? userId}) async {
    final uid = userId ?? ApiConfig.devUserId;
    final http.Response res = await ApiHttp.get(
      '/api/portfolio/investments',
      query: {'userId': uid},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return PortfolioResponse.fromJson(decodeJson(res.body));
    }
    throw Exception('Investments failed: ${res.statusCode}');
  }

  /// Optional: wire to a "Quick Sell All" button later.
  Future<QuickSellAllResponse> sellAll({String? userId}) async {
    final uid = userId ?? ApiConfig.devUserId;
    final http.Response res = await ApiHttp.post(
      '/api/trade/sell-all',
      query: {'userId': uid},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return QuickSellAllResponse.fromJson(decodeJson(res.body));
    }
    throw Exception('Sell-all failed: ${res.statusCode}');
  }
}