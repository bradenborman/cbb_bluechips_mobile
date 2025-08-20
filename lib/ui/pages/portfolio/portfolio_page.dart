import 'package:flutter/material.dart';
import '../../.././models/models.dart';
import '../../../services/portfolio_service.dart';

// Aliased to avoid symbol collisions
import 'widgets/overview_panel.dart' as ov;
import 'widgets/investment_list.dart' as il;

import 'widgets/loading_block.dart';
import 'widgets/error_block.dart';
import 'widgets/portfolio_field.dart';

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

  // Quick Sell (temporarily disabled per design note)
  bool confirmingQuickSale = false;
  RequestStatus quickSaleStatus = RequestStatus.idle;
  QuickSellAllResponse quickSaleResponse = QuickSellAllResponse.empty;

  List<Investment> _investments = const [];

  Future<void> _fetchPortfolio() async {
    setState(() => status = RequestStatus.loading);
    try {
      final o = await _svc.getOverview();
      final inv = await _svc.getInvestments();
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
              // 1) Snapshot (no thin rule)
              SectionCard(
                child: ov.OverviewPanel(
                  leaderboardPosition: overview.leaderboardPosition,
                  username: 'Braden', // wire to auth when ready
                  totalPoints: overview.totalNetWorth,
                  status: status,
                ),
              ),
              const SizedBox(height: 12),

              // 2) Summary
              SectionCard(
                title: 'Summary',
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Builder(
                    builder: (context) {
                      if (status == RequestStatus.loading) {
                        return const LoadingBlock();
                      }
                      if (status == RequestStatus.error) {
                        return const ErrorBlock(
                          text: 'Unable to load your portfolio.',
                        );
                      }
                      return Column(
                        children: [
                          PortfolioField(
                            label: 'Available Points',
                            value: overview.availableNetWorth,
                          ),
                          _thinDivider(context),
                          PortfolioField(
                            label: 'Invested Points',
                            value: overview.investmentsTotal,
                          ),
                          _thinDivider(context),
                          PortfolioField(
                            label: 'Predictions',
                            value: overview.predictionsTotal,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 3) Investments (header with total on the right)
              SectionCard(
                title: 'Investments',
                trailing: _fmt(overview.investmentsTotal),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                  child: il.InvestmentList(
                    items: _investments,
                    onTap: (inv) {
                      // Navigate to Trade screen (adjust route/args if your app differs)
                      Navigator.pushNamed(
                        context,
                        '/trade',
                        arguments: {'teamId': inv.teamId},
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

  Widget _thinDivider(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Divider(
      thickness: 0.75,
      height: 0,
      color: Theme.of(context).dividerColor.withOpacity(0.6),
    ),
  );
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
    final borderColor = scheme.outlineVariant.withOpacity(0.5);

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
                          color: scheme.onSurface.withOpacity(0.7),
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
