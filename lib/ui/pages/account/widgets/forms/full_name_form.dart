import 'package:flutter/material.dart';
import 'package:cbb_bluechips_mobile/services/http_client.dart';
import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';

class FullNameForm extends StatefulWidget {
  final String initialFirst;
  final String initialLast;

  /// Called after a successful save so parent can update UI immediately.
  final void Function(String first, String last)? onSaved;

  const FullNameForm({
    super.key,
    required this.initialFirst,
    required this.initialLast,
    this.onSaved,
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
  void didUpdateWidget(covariant FullNameForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent passes different initials later, reflect them in the inputs.
    if (oldWidget.initialFirst != widget.initialFirst) {
      _first.text = widget.initialFirst;
    }
    if (oldWidget.initialLast != widget.initialLast) {
      _last.text = widget.initialLast;
    }
  }

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
      // get user id from AuthScope
      final auth = AuthScope.of(context, listen: false) as dynamic;
      final String userId =
          auth.currentUser?.userId ??
          auth.currentUser?.id ??
          auth.currentUser?.uid ??
          auth.userId ??
          auth.currentUserId ??
          '';

      if (userId.isEmpty) {
        throw StateError('Missing userId');
      }

      // Use your ApiHttp client (auth already handled in http_client.dart)
      // Adjust path to match your API's update endpoint
      final res = await ApiHttp.post(
        '/api/user/account/$userId/name',
        body: {'firstName': _first.text.trim(), 'lastName': _last.text.trim()},
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        if (!mounted) return;
        // tell parent we saved successfully so it can update immediately
        widget.onSaved?.call(_first.text.trim(), _last.text.trim());
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Name updated')));
      } else {
        throw Exception('Failed: HTTP ${res.statusCode}');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not update name: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            controller: _first,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'First name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _last,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Last name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Required' : null,
            onFieldSubmitted: (_) => _submit(),
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
