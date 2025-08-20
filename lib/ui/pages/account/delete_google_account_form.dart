import 'package:cbb_bluechips_mobile/models/models.dart';
import 'package:flutter/material.dart';
import 'models.dart';
import 'widgets/settings_section.dart';
import 'widgets/user_profile_header.dart';
import 'widgets/unable_to_load_message.dart';
import 'widgets/forms/full_name_form.dart';
import 'widgets/forms/display_name_form.dart';
import 'widgets/forms/password_change_form.dart';
import 'widgets/forms/password_create_form.dart';
import 'widgets/forms/delete_credentials_account_form.dart';
import 'widgets/forms/delete_google_account_form.dart';

class AccountPage extends StatefulWidget {
  static const route = '/account';
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  RequestStatus _status = RequestStatus.loading;
  UserAccount? _account;

  @override
  void initState() {
    super.initState();
    _fetchAccount();
  }

  Future<void> _fetchAccount() async {
    setState(() => _status = RequestStatus.loading);
    try {
      // TODO replace with your API call to /api/account
      await Future.delayed(const Duration(milliseconds: 400));
      const mock = UserAccount(
        firstName: 'Braden',
        lastName: 'Borman',
        email: 'braden@example.com',
        providers: [SignInProvider.google], // flip to credentials to test
        imageUrl: null,
        displayNameStrategy: DisplayNameStrategy.firstLast,
      );
      setState(() {
        _account = mock;
        _status = RequestStatus.idle;
      });
    } catch (_) {
      setState(() => _status = RequestStatus.error);
    }
  }

  bool _hasProvider(SignInProvider p) =>
      _account?.providers.contains(p) == true;

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_status) {
      case RequestStatus.loading:
        body = const Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(),
          ),
        );
        break;
      case RequestStatus.error:
        body = UnableToLoadMessage(
          text: 'Unable to load your account.',
          onRetry: _fetchAccount,
        );
        break;
      case RequestStatus.idle:
        if (_account == null) {
          body = const SizedBox.shrink();
          break;
        }
        final showCredentialsFlows = _hasProvider(SignInProvider.credentials);
        body = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserProfileHeader(account: _account!),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SettingsSection(
                    title: 'Name',
                    child: FullNameForm(
                      initialFirst: _account!.firstName,
                      initialLast: _account!.lastName,
                    ),
                  ),              
                  SettingsSection(
                    title: 'Display Name',
                    subtitle:
                        'Choose how your name is displayed to other users.',
                    child: DisplayNameForm(
                      firstName: _account!.firstName,
                      lastName: _account!.lastName,
                      strategy: _account!.displayNameStrategy,
                    ),
                  ),
                  if (showCredentialsFlows)
                    const SettingsSection(
                      title: 'Update Password',
                      subtitle: 'Enter your old and new passwords.',
                      child: PasswordChangeForm(),
                    )
                  else
                    const SettingsSection(
                      title: 'Create Password',
                      subtitle:
                          'You signed in with Google so your account does not have a password yet.',
                      child: PasswordCreateForm(),
                    ),
                  SettingsSection.danger(
                    title: 'Delete Account',
                    subtitle:
                        'Deleting your account is permanent. All of your user data, portfolio data, and transaction history will be erased forever.',
                    child: showCredentialsFlows
                        ? const DeleteCredentialsAccountForm()
                        : const DeleteGoogleAccountForm(),
                  ),
                ],
              ),
            ),
          ],
        );
        break;
      case RequestStatus.success:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: body,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
