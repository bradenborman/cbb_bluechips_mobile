import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'http_client.dart';

class PortfolioService {
  const PortfolioService();

  Future<Portfolio> getOverview({required String userId}) async {
    final http.Response res = await ApiHttp.get(
      '/api/portfolio/overview',
      query: {'userId': userId},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return Portfolio.fromJson(decodeJson(res.body));
    }
    throw Exception('Overview failed: ${res.statusCode}');
  }

  Future<PortfolioResponse> getInvestments({required String userId}) async {
    final http.Response res = await ApiHttp.get(
      '/api/portfolio/investments',
      query: {'userId': userId},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return PortfolioResponse.fromJson(decodeJson(res.body));
    }
    throw Exception('Investments failed: ${res.statusCode}');
  }

  /// Optional: wire to a "Quick Sell All" button later.
  Future<QuickSellAllResponse> sellAll({required String userId}) async {
    final http.Response res = await ApiHttp.post(
      '/api/trade/sell-all',
      query: {'userId': userId},
    );
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return QuickSellAllResponse.fromJson(decodeJson(res.body));
    }
    throw Exception('Sell-all failed: ${res.statusCode}');
  }

  // ──────────────────────────────────────────────────────────────────────────
  // User display name via API
  // GET /api/user/{userId}  -> schema has firstName, lastName, email,
  // displayNameStrategy: FULL | FIRST_ABBREVIATED | LAST_ABBREVIATED
  // Returns a clean display name for UI use.
  // ──────────────────────────────────────────────────────────────────────────
  Future<String> getUserDisplayName({required String userId}) async {
    final http.Response res = await ApiHttp.get('/api/user/$userId');
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw Exception('User fetch failed: ${res.statusCode}');
    }

    final Map<String, dynamic> j = decodeJson(res.body) as Map<String, dynamic>;

    final String first = (j['firstName'] ?? '').toString().trim();
    final String last = (j['lastName'] ?? '').toString().trim();
    final String email = (j['email'] ?? '').toString().trim();
    final String strat = (j['displayNameStrategy'] ?? 'FULL').toString().trim();

    String cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

    String byStrategy() {
      switch (strat) {
        case 'FIRST_ABBREVIATED':
          // "Braden B."
          if (first.isNotEmpty && last.isNotEmpty) {
            return '${cap(first)} ${cap(last[0])}.';
          }
          break;
        case 'LAST_ABBREVIATED':
          // "B. Borman"
          if (first.isNotEmpty && last.isNotEmpty) {
            return '${cap(first[0])}. ${cap(last)}';
          }
          break;
        case 'FULL':
        default:
          if (first.isNotEmpty || last.isNotEmpty) {
            return [cap(first), cap(last)].where((s) => s.isNotEmpty).join(' ');
          }
      }
      // fallbacks if names missing
      if (email.contains('@')) {
        final local = email.split('@').first;
        final parts = local
            .split(RegExp(r'[._+\-]'))
            .where((p) => p.isNotEmpty);
        return parts.map(cap).join(' ');
      }
      return 'Player';
    }

    return byStrategy();
  }
}