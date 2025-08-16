import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/overview_panel.dart';
import 'widgets/investment_list.dart';
import 'widgets/loading_block.dart';
import 'widgets/error_block.dart';
import 'widgets/portfolio_field.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  Portfolio overview = Portfolio.empty;
  RequestStatus status = RequestStatus.loading;

  bool confirmingQuickSale = false;
  RequestStatus quickSaleStatus = RequestStatus.idle;
  QuickSellAllResponse quickSaleResponse = QuickSellAllResponse.empty;

  // Replace this with your real fetch
  Future<void> _fetchPortfolio() async {
    setState(() => status = RequestStatus.loading);
    await Future.delayed(const Duration(milliseconds: 600));
    // Fake data to mirror your web layout
    setState(() {
      overview = Portfolio(
        leaderboardPosition: 14,
        totalNetWorth: 124_500,
        availableNetWorth: 18_700,
        investmentsTotal: 92_300,
      );
      status = RequestStatus.idle;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchPortfolio();
  }

  @override
  Widget build(BuildContext context) {
    final pageBg = Theme.of(context).colorScheme.surface;
    return Scaffold(
      appBar: AppBar(title: const Text('Portfolio'), centerTitle: true),
      backgroundColor: pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section wrapper like your <Section>
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  OverviewPanel(
                    leaderboardPosition: overview.leaderboardPosition,
                    username: 'Braden', // wire to auth when ready
                    totalPoints: overview.totalNetWorth,
                    status: status,
                  ),
                  if (status == RequestStatus.loading)
                    const LoadingBlock()
                  else if (status == RequestStatus.error)
                    const ErrorBlock(text: 'Unable to load your portfolio.')
                  else
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          PortfolioField(
                            label: 'Available Points',
                            value: overview.availableNetWorth,
                          ),
                          const SizedBox(height: 12),
                          PortfolioField(
                            label: 'Invested Points',
                            value: overview.investmentsTotal,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Investments list
            Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: InvestmentList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
