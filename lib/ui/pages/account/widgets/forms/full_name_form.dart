// lib/ui/pages/account/widgets/forms/full_name_form.dart
import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/http_client.dart' show ApiHttp;
import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';

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

    // get userId from your auth scope
    final auth = AuthScope.of(context, listen: false) as dynamic;
    final String userId =
        auth.currentUser?.userId ??
        auth.currentUser?.id ??
        auth.currentUser?.uid ??
        auth.userId ??
        auth.currentUserId ??
        '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Missing user id')));
      return;
    }

    setState(() => _submitting = true);
    try {
      final res = await ApiHttp.put(
        '/api/admin/users',
        body: {
          'userId': userId,
          'firstName': _first.text.trim(),
          'lastName': _last.text.trim(),
          // You can include 'email', 'vip', 'userRole' if you choose,
          // but they’re optional for this update per the spec.
        },
      );

      if (res.statusCode < 200 || res.statusCode >= 300) {
        throw StateError('HTTP ${res.statusCode}');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Name updated')));
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
