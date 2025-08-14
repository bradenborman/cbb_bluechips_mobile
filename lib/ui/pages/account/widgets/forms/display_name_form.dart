import 'package:flutter/material.dart';
import '../../../account/models.dart';

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

class _DisplayNameFormState extends State<DisplayNameForm> {
  late DisplayNameStrategy _strategy = widget.strategy;
  bool _submitting = false;

  String _preview() {
    switch (_strategy) {
      case DisplayNameStrategy.firstLast:
        return '${widget.firstName} ${widget.lastName}';
      case DisplayNameStrategy.firstLastInitial:
        final initial = widget.lastName.isNotEmpty
            ? '${widget.lastName[0]}.'
            : '';
        return '${widget.firstName} $initial';
      case DisplayNameStrategy.handleOnly:
        return '@${widget.firstName.toLowerCase()}';
    }
  }

  Future<void> _save() async {
    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 400)); // TODO API
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Display name updated')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RadioListTile<DisplayNameStrategy>(
          value: DisplayNameStrategy.firstLast,
          groupValue: _strategy,
          onChanged: (v) => setState(() => _strategy = v!),
          title: const Text('First Last'),
        ),
        RadioListTile<DisplayNameStrategy>(
          value: DisplayNameStrategy.firstLastInitial,
          groupValue: _strategy,
          onChanged: (v) => setState(() => _strategy = v!),
          title: const Text('First L.'),
        ),
        RadioListTile<DisplayNameStrategy>(
          value: DisplayNameStrategy.handleOnly,
          groupValue: _strategy,
          onChanged: (v) => setState(() => _strategy = v!),
          title: const Text('Handle only'),
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
