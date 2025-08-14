import 'package:flutter/material.dart';

class DeleteGoogleAccountForm extends StatefulWidget {
  const DeleteGoogleAccountForm({super.key});

  @override
  State<DeleteGoogleAccountForm> createState() =>
      _DeleteGoogleAccountFormState();
}

class _DeleteGoogleAccountFormState extends State<DeleteGoogleAccountForm> {
  bool _confirmChecked = false;
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_confirmChecked) return;
    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 600)); // TODO API call
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account deleted')));
      // TODO: navigate to signed-out screen
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: _confirmChecked,
          onChanged: (v) => setState(() => _confirmChecked = v ?? false),
          title: const Text('I understand this action is permanent'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Delete account'),
        ),
      ],
    );
  }
}
