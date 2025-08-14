import 'package:flutter/material.dart';

class PasswordCreateForm extends StatefulWidget {
  const PasswordCreateForm({super.key});

  @override
  State<PasswordCreateForm> createState() => _PasswordCreateFormState();
}

class _PasswordCreateFormState extends State<PasswordCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _new = TextEditingController();
  final _confirm = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _new.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validateNew(String? v) {
    if (v == null || v.length < 8) return 'Must be at least 8 characters';
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_new.text != _confirm.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
      return;
    }
    setState(() => _submitting = true);
    try {
      await Future.delayed(const Duration(milliseconds: 450)); // TODO API
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Password created')));
      _new.clear();
      _confirm.clear();
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
            controller: _new,
            decoration: const InputDecoration(labelText: 'New password'),
            obscureText: true,
            validator: _validateNew,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _confirm,
            decoration: const InputDecoration(
              labelText: 'Confirm new password',
            ),
            obscureText: true,
            validator: _validateNew,
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
                  : const Text('Create password'),
            ),
          ),
        ],
      ),
    );
  }
}
