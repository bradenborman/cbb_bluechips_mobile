import 'package:flutter/material.dart';

class FullNameForm extends StatefulWidget {
  final String initialFirst;
  final String initialLast;
  const FullNameForm({
    super.key,
    required this.initialFirst,
    required this.initialLast,
  });

  @override
  State<FullNameForm> createState() => _FullNameFormState();
}

class _FullNameFormState extends State<FullNameForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _first = TextEditingController(
    text: widget.initialFirst,
  );
  late final TextEditingController _last = TextEditingController(
    text: widget.initialLast,
  );
  bool _submitting = false;

  @override
  void dispose() {
    _first.dispose();
    _last.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 400)); // TODO wire API
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name updated')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _first,
            decoration: const InputDecoration(labelText: 'First name'),
            textInputAction: TextInputAction.next,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _last,
            decoration: const InputDecoration(labelText: 'Last name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
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
      ),
    );
  }
}
