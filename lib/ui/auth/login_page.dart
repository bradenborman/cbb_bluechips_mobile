import 'package:cbb_bluechips_mobile/services/auth/auth_scope.dart';
import 'package:flutter/material.dart';
import '../../theme.dart';
import 'package:cbb_bluechips_mobile/services/auth/auth_repository_api.dart';

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
  bool _busyGoogle = false;
  bool _busyEmail = false;
  bool _isCreateMode = false; // NEW: toggle sign in vs create
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
      await auth.signInWithApple();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busyApple = false);
    }
  }

  Future<void> _googleSignIn() async {
    final auth = AuthScope.of(context, listen: false);
    setState(() {
      _busyGoogle = true;
      _error = null;
    });
    try {
      await auth.signInWithGoogle();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busyGoogle = false);
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
      if (_isCreateMode) {
        await auth.createAccount(_email.text.trim(), _password.text);
      } else {
        await auth.signIn(_email.text.trim(), _password.text);
      }
    } catch (e) {
      final msg = _humanizeError(e);
      setState(() => _error = msg);
    } finally {
      if (mounted) setState(() => _busyEmail = false);
    }
  }

  String _humanizeError(Object e) {
    if (e is AuthError) return e.message;
    final s = e.toString();
    if (s.contains('HandshakeException')) return 'Network/SSL error.';
    return 'Something went wrong. Please try again.';
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
                    _isCreateMode ? 'Create your account' : 'Welcome back',
                    style: t.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isCreateMode
                        ? 'Enter your email and a password to get started.'
                        : 'Choose how you want to sign in.',
                    style: t.textTheme.bodyMedium?.copyWith(
                      color: onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),

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

                  // SSO buttons (disabled for now, but UI stays)
                  if (!_isCreateMode) ...[
                    SizedBox(
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: _busyApple ? null : _appleSignIn,
                        icon: const Text('', style: TextStyle(fontSize: 20)),
                        label: _busyApple
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
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
                    SizedBox(
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _busyGoogle ? null : _googleSignIn,
                        icon: _GoogleLogo(),
                        label: _busyGoogle
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Continue with Google',
                              ),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: onSurface.withOpacity(0.12)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                  ],

                  const SizedBox(height: 12),

                  // Email form (always visible to drive primary flow)
                  _EmailForm(
                    formKey: _form,
                    email: _email,
                    password: _password,
                    busy: _busyEmail,
                    onSubmit: _emailSubmit,
                    ctaText: _isCreateMode ? 'Create account' : 'Continue',
                  ),

                  const SizedBox(height: 12),

                  // Mode switch
                  TextButton(
                    onPressed: _busyEmail
                        ? null
                        : () {
                            setState(() {
                              _isCreateMode = !_isCreateMode;
                              _error = null;
                            });
                          },
                    child: Text(
                      _isCreateMode
                          ? 'Already have an account? Sign in'
                          : 'New here? Create an account',
                    ),
                  ),

                  const Spacer(),

                  Opacity(
                    opacity: 0.6,
                    child: Text(
                      'Email & password auth. Apple/Google coming soon.',
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

class _GoogleLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/google_g.png',
      width: 20,
      height: 20,
      errorBuilder: (_, __, ___) => const Icon(Icons.mail_outline, size: 20),
    );
  }
}

class _EmailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController email;
  final TextEditingController password;
  final bool busy;
  final VoidCallback onSubmit;
  final String ctaText;

  const _EmailForm({
    required this.formKey,
    required this.email,
    required this.password,
    required this.busy,
    required this.onSubmit,
    required this.ctaText,
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
                  : Text(ctaText),
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
