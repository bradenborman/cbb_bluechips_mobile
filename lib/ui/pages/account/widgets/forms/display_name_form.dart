// lib/ui/pages/account/widgets/forms/display_name_form.dart
import 'package:flutter/material.dart';
import '../../../account/models.dart'; // DisplayNameStrategy lives here
import 'package:cbb_bluechips_mobile/services/http_client.dart' show ApiHttp;
import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';

class DisplayNameForm extends StatefulWidget {
  final String firstName;
  final String lastName;
  final DisplayNameStrategy strategy;

  const DisplayNameForm({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.strategy,
  });

  @override
  State<DisplayNameForm> createState() => _DisplayNameFormState();
}

enum _Kind { full, firstAbbrev, lastAbbrev, handle }

class _DisplayNameFormState extends State<DisplayNameForm> {
  late DisplayNameStrategy _strategy = widget.strategy;
  bool _submitting = false;

  String _enumName(DisplayNameStrategy v) =>
      v.toString().split('.').last; // raw enum case name

  _Kind _kindFor(DisplayNameStrategy v) {
    final s = _enumName(v).toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (s.contains('handle') || s.contains('username')) return _Kind.handle;

    final hasFirst = s.contains('first');
    final hasLast = s.contains('last');
    final isAbbrev = s.contains('abbrev') || s.contains('initial');

    if (hasFirst && hasLast && !isAbbrev) return _Kind.full;
    if (hasFirst && isAbbrev) return _Kind.firstAbbrev;
    if (hasLast && isAbbrev) return _Kind.lastAbbrev;
    return _Kind.full;
  }

  String _label(DisplayNameStrategy v) {
    switch (_kindFor(v)) {
      case _Kind.full:
        return 'First Last';
      case _Kind.firstAbbrev:
        return 'First L.';
      case _Kind.lastAbbrev:
        return 'F. Last';
      case _Kind.handle:
        return 'Handle only';
    }
  }

  String _preview() {
    final first = widget.firstName;
    final last = widget.lastName;
    switch (_kindFor(_strategy)) {
      case _Kind.full:
        return '$first $last';
      case _Kind.firstAbbrev:
        final initial = last.isNotEmpty ? '${last[0]}.' : '';
        return '$first $initial';
      case _Kind.lastAbbrev:
        final initial = first.isNotEmpty ? '${first[0]}.' : '';
        return '$initial $last';
      case _Kind.handle:
        return '@${first.toLowerCase()}';
    }
  }

  // Map your enum to what the API actually accepts.
  // API supports: FULL, FIRST_ABBREVIATED, LAST_ABBREVIATED
  String _apiValue(DisplayNameStrategy v) {
    switch (_kindFor(v)) {
      case _Kind.full:
        return 'FULL';
      case _Kind.firstAbbrev:
        return 'FIRST_ABBREVIATED';
      case _Kind.lastAbbrev:
        return 'LAST_ABBREVIATED';
      case _Kind.handle:
        // Not supported by API
        return 'FULL'; // safe fallback if you prefer; or block in _save()
    }
  }

  // Try to grab userId from your AuthScope without relying on an exact field name.
  String _userIdFromScope(BuildContext context) {
    final auth = AuthScope.of(context, listen: false) as dynamic;
    return auth.currentUser?.userId ??
        auth.currentUser?.id ??
        auth.currentUser?.uid ??
        auth.userId ??
        auth.currentUserId ??
        '';
  }

  Future<void> _save() async {
    // If user chose "handle only" but API doesn’t support it, block and tell them.
    if (_kindFor(_strategy) == _Kind.handle) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('“Handle only” isn’t supported by the API yet.'),
        ),
      );
      return;
    }

    final userId = _userIdFromScope(context);
    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Can’t update: missing user id.')),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final res = await ApiHttp.put(
        '/api/user/display-name-strategy',
        body: {'userId': userId, 'strategy': _apiValue(_strategy)},
      );
      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw StateError('HTTP ${res.statusCode}');
      }
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Display name updated')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final values = DisplayNameStrategy.values; // uses your real enum

    return Column(
      children: [
        for (final v in values)
          RadioListTile<DisplayNameStrategy>(
            value: v,
            groupValue: _strategy,
            onChanged: (nv) => setState(() => _strategy = nv!),
            title: Text(_label(v)),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Preview: '),
            Text(
              _preview(),
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: _submitting ? null : _save,
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }
}