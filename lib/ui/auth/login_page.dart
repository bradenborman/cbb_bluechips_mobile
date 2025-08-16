import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'package:cbb_bluechips_mobile/services/auth/auth_gate.dart';

class LoginPage extends StatefulWidget {
  static const route = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busyApple = false;
  bool _busyEmail = false;
  bool _showEmail = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _appleSignIn() async {
    final auth = AuthScope.of(context, listen: false);
    setState(() {
      _busyApple = true;
      _error = null;
    });
    try {
      // Stubbed Apple login: creates an 8-hour session
      await auth.signInWithApple();
      // AuthGate will switch to AppShell automatically
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busyApple = false);
    }
  }

  Future<void> _emailSubmit() async {
    final auth = AuthScope.of(context, listen: false);
    if (!(_form.currentState?.validate() ?? false)) return;

    setState(() {
      _busyEmail = true;
      _error = null;
    });
    try {
      await auth.signIn(_email.text.trim(), _password.text);
      // AuthGate will switch to AppShell automatically
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busyEmail = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final onSurface = t.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: Image.asset(
          'assets/images/cbb-blue-chips-nav-logo.png',
          height: 26,
          fit: BoxFit.contain,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Welcome back',
                    style: t.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose how you want to sign in.',
                    style: t.textTheme.bodyMedium?.copyWith(
                      color: onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (_error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        _error!,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),

                  // Sign in with Apple (primary — stubbed)
                  SizedBox(
                    height: 48,
                    child: FilledButton.icon(
                      onPressed: _busyApple ? null : _appleSignIn,
                      icon: const Text("", style: TextStyle(fontSize: 20)),
                      label: _busyApple
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign in with Apple'),
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Divider with "or"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: onSurface.withOpacity(0.15),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'or',
                          style: t.textTheme.bodySmall?.copyWith(
                            color: onSurface.withOpacity(0.6),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: onSurface.withOpacity(0.15),
                          height: 1,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Toggle for email sign-in
                  OutlinedButton.icon(
                    onPressed: () => setState(() => _showEmail = !_showEmail),
                    icon: const Icon(Icons.email_outlined),
                    label: Text(
                      _showEmail ? 'Hide email sign in' : 'Sign in with Email',
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  // Expandable email form
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeInOut,
                    child: _showEmail
                        ? Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: _EmailForm(
                              formKey: _form,
                              email: _email,
                              password: _password,
                              busy: _busyEmail,
                              onSubmit: _emailSubmit,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  const Spacer(),

                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      'Mock auth — no network used. Session persists for 8 hours.',
                      textAlign: TextAlign.center,
                      style: t.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final bool busy;
  final VoidCallback onSubmit;

  const _EmailForm({
    required this.formKey,
    required this.email,
    required this.password,
    required this.busy,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final onSurface = t.colorScheme.onSurface;

    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: email,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'you@example.com',
              prefixIcon: Icon(Icons.email_outlined),
            ),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Email is required';
              if (!v.contains('@')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: password,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock_outline),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 6) return 'Must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            width: double.infinity,
            child: FilledButton(
              onPressed: busy ? null : onSubmit,
              child: busy
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continue'),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'By continuing you agree to the Terms and the Privacy Policy.',
            textAlign: TextAlign.center,
            style: t.textTheme.bodySmall?.copyWith(
              color: onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
