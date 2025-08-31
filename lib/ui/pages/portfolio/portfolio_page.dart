import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';
import 'package:flutter/material.dart';
import '../../.././models/models.dart';
import '../../../services/portfolio_service.dart';

// Keep existing widgets for reuse
import 'widgets/loading_block.dart';
import 'widgets/error_block.dart';
import 'widgets/investment_list.dart' as il;

// New combined snapshot card
import 'widgets/snapshot_card.dart';

class PortfolioPage extends StatefulWidget {
  static const route = '/portfolio';
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final _svc = const PortfolioService();

  Portfolio overview = Portfolio.empty;
  RequestStatus status = RequestStatus.loading;

  bool confirmingQuickSale = false;
  RequestStatus quickSaleStatus = RequestStatus.idle;
  QuickSellAllResponse quickSaleResponse = QuickSellAllResponse.empty;

  List<Investment> _investments = const [];

  Future<void> _fetchPortfolio() async {
    setState(() => status = RequestStatus.loading);
    try {
      // pull the real userId from the auth scope
      final uid = AuthScope.of(context, listen: false).currentUser?.userId;
      if (uid == null || uid.isEmpty) {
        setState(() => status = RequestStatus.error);
        return;
      }

      final o = await _svc.getOverview(userId: uid);
      final inv = await _svc.getInvestments(userId: uid);

      setState(() {
        overview = o;
        _investments = inv.usersInvestments;
        status = RequestStatus.success;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Portfolio fetch error: $e');
      setState(() => status = RequestStatus.error);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPortfolio();
  }

  String _fmt(int v) {
    final s = v.toString();
    final b = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      b.write(s[i]);
      if (idx > 1 && idx % 3 == 1) b.write(',');
    }
    return b.toString();
  }

  @override
  Widget build(BuildContext context) {
    final pageBg = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio'), centerTitle: true),
      backgroundColor: pageBg,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchPortfolio,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Combined Snapshot (rank/name + balances in one bordered card)
              SectionCard(
                child: Builder(
                  builder: (context) {
                    if (status == RequestStatus.loading) {
                      return const LoadingBlock();
                    }
                    if (status == RequestStatus.error) {
                      return const Padding(
                        padding: EdgeInsets.all(12),
                        child: ErrorBlock(
                          text: 'Unable to load your portfolio.',
                        ),
                      );
                    }

                    // Use userId as a safe display token (AppUser may not have firstName)
                    final appUser = AuthScope.of(
                      context,
                      listen: false,
                    ).currentUser;
                    final displayName = appUser?.displayName ?? 'Player';

                    return SnapshotCard(
                      leaderboardPosition: overview.leaderboardPosition,
                      displayName: displayName,
                      totalPoints: overview.totalNetWorth,
                      availablePoints: overview.availableNetWorth,
                      investedPoints: overview.investmentsTotal,
                      predictionsPoints: overview.predictionsTotal,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Investments
              SectionCard(
                title: 'Investments',
                trailing: _fmt(overview.investmentsTotal),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: il.InvestmentList(
                    items: _investments,
                    abbrevOnly:
                        true, // show 2-letter ticker to avoid truncation
                    showSeed: false, // keep seed for Trade page instead
                    onTap: (inv) {
                      // Navigate to Trade screen (existing route/args)
                      Navigator.pushNamed(
                        context,
                        '/trade',
                        arguments: {'teamId': inv.teamId, 'from': 'portfolio'},
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reusable rounded card with subtle outline, optional title and trailing text.
class SectionCard extends StatelessWidget {
  final String? title;
  final String? trailing;
  final Widget child;

  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    final borderColor = scheme.outlineVariant.withValues(alpha: 0.5);

    return Material(
      elevation: 1,
      color: scheme.surfaceContainerHighest,
      shape: shape,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (title != null || trailing != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    if (title != null)
                      Text(
                        title!,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    const Spacer(),
                    if (trailing != null)
                      Text(
                        trailing!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                  ],
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }
}
