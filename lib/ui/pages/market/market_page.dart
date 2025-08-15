import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Route so you can do routes['/market'] or Navigator.pushNamed(context, MarketPage.route)
class MarketPage extends StatefulWidget {
  static const route = '/market';
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

/// ===== Models and Enums =====

enum RequestStatus { idle, loading, error }

enum MarketFilterOption { all, inProgress, completed }

/// In your web app you had RealtimeMessageType.UpdateMatchStartTime
enum RealtimeMessageType { updateMatchStartTime, unknown }

RealtimeMessageType _parseMessageType(String? s) {
  switch (s) {
    case 'UpdateMatchStartTime':
      return RealtimeMessageType.updateMatchStartTime;
    default:
      return RealtimeMessageType.unknown;
  }
}

class MarketModel {
  final List<MatchModel> matches;
  const MarketModel({required this.matches});

  factory MarketModel.fromJson(Map<String, dynamic> json) {
    final list = (json['matches'] as List? ?? [])
        .map((e) => MatchModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return MarketModel(matches: list);
  }
}

enum MatchStatus { notStarted, inProgress, completed }

MatchStatus matchStatusFromString(String? s) {
  switch ((s ?? '').toLowerCase()) {
    case 'inprogress':
      return MatchStatus.inProgress;
    case 'completed':
      return MatchStatus.completed;
    default:
      return MatchStatus.notStarted;
  }
}

class MatchModel {
  final String matchId;
  String startTime; // updated via realtime
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final MatchStatus status;

  MatchModel({
    required this.matchId,
    required this.startTime,
    required this.homeTeam,
    required this.awayTeam,
    required this.status,
    this.homeScore,
    this.awayScore,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      matchId: json['matchId'] as String,
      startTime: json['startTime'] as String? ?? '',
      homeTeam: json['homeTeam'] as String? ?? 'Home',
      awayTeam: json['awayTeam'] as String? ?? 'Away',
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      status: matchStatusFromString(json['status'] as String?),
    );
  }

  MatchModel copyWith({
    String? startTime,
    int? homeScore,
    int? awayScore,
    MatchStatus? status,
  }) {
    return MatchModel(
      matchId: matchId,
      startTime: startTime ?? this.startTime,
      homeTeam: homeTeam,
      awayTeam: awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
    );
  }
}

/// ===== State + Controller =====

class _MarketState {
  final MarketModel market;
  final RequestStatus status;
  final MarketFilterOption filter;

  const _MarketState({
    required this.market,
    required this.status,
    required this.filter,
  });

  _MarketState copyWith({
    MarketModel? market,
    RequestStatus? status,
    MarketFilterOption? filter,
  }) {
    return _MarketState(
      market: market ?? this.market,
      status: status ?? this.status,
      filter: filter ?? this.filter,
    );
  }
}

class _MarketPageState extends State<MarketPage> {
  _MarketState _state = const _MarketState(
    market: MarketModel(matches: []),
    status: RequestStatus.loading,
    filter: MarketFilterOption.all,
  );

  final ScrollController _scroll = ScrollController();
  bool _showBackToTop = false;

  WebSocketChannel? _channel;
  StreamSubscription? _wsSub;

  @override
  void initState() {
    super.initState();
    _fetchMarket();
    _setupScrollHandler();
    _connectSocket();
  }

  @override
  void dispose() {
    _scroll.dispose();
    _wsSub?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  void _setupScrollHandler() {
    _scroll.addListener(() {
      final show = _scroll.position.pixels > 600;
      if (show != _showBackToTop) {
        setState(() => _showBackToTop = show);
      }
    });
  }

  /// Adjust baseUrl to your API host when you hook the backend
  static const String _baseUrl = ''; // example: 'https://api.cbbbluechips.com'
  static const String _marketPath = '/api/market';

  Future<void> _fetchMarket() async {
    setState(() => _state = _state.copyWith(status: RequestStatus.loading));

    await Future.delayed(const Duration(milliseconds: 500)); // simulate load

    final mockMatches = [
      MatchModel(
        matchId: 'm1',
        startTime: '7:05 PM CT',
        homeTeam: 'Duke',
        awayTeam: 'UNC',
        homeScore: 64,
        awayScore: 62,
        status: MatchStatus.inProgress,
      ),
      MatchModel(
        matchId: 'm2',
        startTime: '8:30 PM CT',
        homeTeam: 'Kansas',
        awayTeam: 'Kentucky',
        status: MatchStatus.notStarted,
      ),
      MatchModel(
        matchId: 'm3',
        startTime: 'Final',
        homeTeam: 'Gonzaga',
        awayTeam: 'Baylor',
        homeScore: 72,
        awayScore: 75,
        status: MatchStatus.completed,
      ),
    ];

    final mockMarket = MarketModel(matches: mockMatches);

    setState(() {
      _state = _state.copyWith(market: mockMarket, status: RequestStatus.idle);
    });
  }

  /*
  Future<void> _fetchMarket() async {
    setState(() => _state = _state.copyWith(status: RequestStatus.loading));
    try {
      final uri = Uri.parse(
        _baseUrl.isEmpty ? _marketPath : '$_baseUrl$_marketPath',
      );

      final res = await http.get(uri);
      if (res.statusCode != 200) {
        throw Exception('bad status: ${res.statusCode}');
      }

      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final market = MarketModel.fromJson(data);

      setState(() {
        _state = _state.copyWith(market: market, status: RequestStatus.idle);
      });
    } catch (e) {
      // If you need to mirror your authCheck(session), you can place a token refresh here
      setState(() => _state = _state.copyWith(status: RequestStatus.error));
    }
  }
  */

void _connectSocket() {
  // No realtime for mock mode
}

  /*

  /// Connect to your realtime service and handle UpdateMatchStartTime
  void _connectSocket() {
    // If you have a Socket.io server, switch to socket_io_client package.
    // For a standard WebSocket, use web_socket_channel as below.
    const wsUrl = ''; // example: 'wss://realtime.cbbbluechips.com/ws'
    if (wsUrl.isEmpty) return;

    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    _wsSub = _channel!.stream.listen((event) {
      try {
        final msg = jsonDecode(event as String) as Map<String, dynamic>;
        final type = _parseMessageType(msg['type'] as String?);
        if (type == RealtimeMessageType.updateMatchStartTime) {
          final matchId = msg['matchId'] as String?;
          final startTime = msg['startTime'] as String?;
          if (matchId != null && startTime != null) {
            _updateMatchStartTime(matchId, startTime);
          }
        }
      } catch (_) {
        // ignore malformed frames
      }
    });
  }
*/

  void _updateMatchStartTime(String matchId, String startTime) {
    final updated = _state.market.matches.map((m) {
      if (m.matchId == matchId) {
        return m.copyWith(startTime: startTime);
      }
      return m;
    }).toList();

    setState(() {
      _state = _state.copyWith(market: MarketModel(matches: updated));
    });
  }

  List<MatchModel> _filtered() {
    switch (_state.filter) {
      case MarketFilterOption.inProgress:
        return _state.market.matches
            .where((m) => m.status == MatchStatus.inProgress)
            .toList();
      case MarketFilterOption.completed:
        return _state.market.matches
            .where((m) => m.status == MatchStatus.completed)
            .toList();
      case MarketFilterOption.all:
        return _state.market.matches;
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Market'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _fetchMarket,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Stack(
        children: [
          content,
          if (_state.status == RequestStatus.loading) const _LoadingOverlay(),
        ],
      ),
      floatingActionButton: _showBackToTop
          ? FloatingActionButton(
              onPressed: () {
                _scroll.animateTo(
                  0,
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeOut,
                );
              },
              tooltip: 'Back to top',
              child: const Icon(Icons.vertical_align_top),
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_state.status == RequestStatus.loading) {
      // Keep the main tree stable while overlay shows loader
      // Return empty container so overlay is visible
      return const SizedBox.expand();
    }

    if (_state.status == RequestStatus.error) {
      return Center(
        child: _LabelAndDescription(
          label: 'Something went wrong',
          desc:
              'Could not load market. Pull to retry or tap the refresh button.',
        ),
      );
    }

    if (_state.market.matches.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'No matches today!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Please check back at another time.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final options = MarketFilterOption.values;
    final filtered = _filtered();

    return RefreshIndicator(
      onRefresh: _fetchMarket,
      child: ListView(
        controller: _scroll,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _FilterChipsRow(
            selected: _state.filter,
            options: options,
            onSelected: (opt) =>
                setState(() => _state = _state.copyWith(filter: opt)),
          ),
          const Divider(height: 24),
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white10),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 220,
                child: _LabelAndDescription(
                  label: 'No matches found!',
                  desc: 'Please try another filter.',
                ),
              ),
            )
          else
            ..._buildMatchList(filtered),
        ],
      ),
    );
  }

  List<Widget> _buildMatchList(List<MatchModel> matches) {
    // Force the list to be List<Widget> so we can append SizedBox/Align later.
    final List<Widget> tiles = matches
        .map<Widget>((m) => _MatchTile(key: ValueKey(m.matchId), match: m))
        .toList();

    // Show a subtle back to top hint at the end if many rows
    if (tiles.length > 3) {
      tiles.add(const SizedBox(height: 12));
      tiles.add(
        Align(
          alignment: Alignment.center,
          child: TextButton.icon(
            onPressed: () {
              _scroll.animateTo(
                0,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            },
            icon: const Icon(Icons.arrow_upward),
            label: const Text('Back to top'),
          ),
        ),
      );
    }

    // Add spacing between cards
    final spaced = <Widget>[];
    for (var i = 0; i < tiles.length; i++) {
      spaced.add(tiles[i]);
      if (i != tiles.length - 1) spaced.add(const SizedBox(height: 12));
    }
    return spaced;
  }
}

/// ===== UI Pieces =====

class _FilterChipsRow extends StatelessWidget {
  final MarketFilterOption selected;
  final List<MarketFilterOption> options;
  final ValueChanged<MarketFilterOption> onSelected;

  const _FilterChipsRow({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  String _label(MarketFilterOption opt) {
    switch (opt) {
      case MarketFilterOption.all:
        return 'All';
      case MarketFilterOption.inProgress:
        return 'In Progress';
      case MarketFilterOption.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: options
          .map(
            (opt) => ChoiceChip(
              label: Text(_label(opt)),
              selected: selected == opt,
              onSelected: (_) => onSelected(opt),
            ),
          )
          .toList(),
    );
  }
}

class _MatchTile extends StatelessWidget {
  final MatchModel match;
  const _MatchTile({required this.match, super.key});

  String _statusText(MatchStatus s) {
    switch (s) {
      case MatchStatus.inProgress:
        return 'Live';
      case MatchStatus.completed:
        return 'Final';
      case MatchStatus.notStarted:
        return 'Scheduled';
    }
  }

  Color _statusColor(BuildContext context, MatchStatus s) {
    switch (s) {
      case MatchStatus.inProgress:
        return Colors.green;
      case MatchStatus.completed:
        return Theme.of(context).colorScheme.secondary;
      case MatchStatus.notStarted:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(context, match.status);
    final hasScore = match.homeScore != null && match.awayScore != null;

    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with status pill and start time
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.50),
                    ),
                  ),
                  child: Text(
                    _statusText(match.status),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      match.startTime.isEmpty ? 'TBD' : match.startTime,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Teams and scores
            Row(
              children: [
                Expanded(
                  child: _TeamLine(
                    name: match.awayTeam,
                    score: hasScore ? match.awayScore : null,
                    bold:
                        hasScore &&
                        (match.awayScore ?? 0) > (match.homeScore ?? 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _TeamLine(
                    name: match.homeTeam,
                    score: hasScore ? match.homeScore : null,
                    bold:
                        hasScore &&
                        (match.homeScore ?? 0) > (match.awayScore ?? 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Actions row. Hook your prop/market actions here later.
            Row(
              children: [
                TextButton.icon(
                  onPressed: () {
                    // TODO: navigate to match detail or bet sheet
                  },
                  icon: const Icon(Icons.bar_chart),
                  label: const Text('Open market'),
                ),
                const Spacer(),
                IconButton(
                  tooltip: 'Favorite',
                  onPressed: () {
                    // TODO: toggle favorite
                  },
                  icon: const Icon(Icons.star_border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TeamLine extends StatelessWidget {
  final String name;
  final int? score;
  final bool bold;
  const _TeamLine({required this.name, this.score, this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = bold
        ? const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)
        : const TextStyle(fontSize: 18, fontWeight: FontWeight.w600);

    return Row(
      children: [
        Expanded(child: Text(name, style: style)),
        if (score != null)
          Text(score.toString(), style: style, textAlign: TextAlign.right),
      ],
    );
  }
}

class _LabelAndDescription extends StatelessWidget {
  final String label;
  final String desc;
  const _LabelAndDescription({required this.label, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(desc, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: Colors.black.withValues(alpha: 0.08),
        child: const Center(child: _WrappedSpinner()),
      ),
    );
  }
}

class _WrappedSpinner extends StatelessWidget {
  const _WrappedSpinner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: const SizedBox(
        height: 36,
        width: 36,
        child: CircularProgressIndicator(strokeWidth: 3),
      ),
    );
  }
}
