import 'package:cbb_bluechips_mobile/ui/widgets/legal/cbb_link.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../widgets/legal/contact_list.dart';

class AboutPage extends StatelessWidget {
  static const route = '/about';
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('About & Legal'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'About'),
              Tab(text: 'Privacy'),
              Tab(text: 'Terms'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _AboutTab(),
            _PrivacyPolicyTab(),
            _TermsAndConditionsTab(),
          ],
        ),
      ),
    );
  }
}

class _AboutTab extends StatelessWidget {
  const _AboutTab();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _H1('About CBB Blue Chips'),
              const SizedBox(height: 8),
              Text(
                'CBB Blue Chips is a free‑to‑play online fantasy sports game that revolves '
                'around the annual Men\'s College Basketball Tournament in March.',
                style: textStyle,
              ),
              const SizedBox(height: 16),
              Text(
                'We’re a small, community-driven project. Points in the app are for gameplay only '
                'and have no real monetary value.',
                style: textStyle,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  FilledButton.tonal(
                    onPressed: () => launchUrlString(CBBLink.url),
                    child: const Text('Visit Website'),
                  ),
                  OutlinedButton(
                    onPressed: () =>
                        launchUrlString('mailto:support@cbbbluechips.com'),
                    child: const Text('Contact Support'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              _H2('Contact'),
              const SizedBox(height: 8),
              const LegalContactList(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrivacyPolicyTab extends StatelessWidget {
  const _PrivacyPolicyTab();

  static const lastUpdated = 'March 15, 2024';

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _H1('Privacy Policy'),
              Text('Last updated: $lastUpdated', style: body),
              const SizedBox(height: 12),
              _P(
                'Protecting your private information is our priority. This Statement of Privacy '
                'applies to ',
              ),
              const CBBInlineLink(),
              _P(
                ' and CBB Blue Chips and governs data collection and usage. '
                'The CBB Blue Chips website is a free to play fantasy sports game site. '
                'By using the CBB Blue Chips website, you consent to the data practices described in this statement.',
              ),
              const SizedBox(height: 20),

              _H2('Collection of your Personal Information'),
              _P(
                'In order to better provide you with products and services offered, '
                'CBB Blue Chips may collect personally identifiable information, such as your:',
              ),
              const _BulletList(
                items: ['First and Last Name', 'Email Address'],
              ),
              _P(
                'If you opt to sign up via a third party social sign in, your name and email will be '
                'automatically provided to us.',
              ),
              _P(
                'If you purchase CBB Blue Chips\'s products and services, we collect billing and credit card '
                'information. This information is used to complete the purchase transaction.',
              ),
              _P(
                'We do not collect any personal information about you unless you voluntarily provide it to us. '
                'However, you may be required to provide certain personal information to us when you elect to use '
                'certain products or services. These may include: (a) registering for an account; (b) entering a '
                'promotion sponsored by us or one of our partners; (c) signing up for special offers from selected '
                'third parties; (d) sending us an email message; (e) submitting your credit card or other payment '
                'information when ordering and purchasing products and services. To wit, we will use your information '
                'for, but not limited to, communicating with you in relation to services and/or products you have '
                'requested from us. We also may gather additional personal or non-personal information in the future.',
              ),
              const SizedBox(height: 20),

              _H2('Public Account Information'),
              _P(
                'Upon creating your account, your name, rank, and total fantasy points will immediately be visible '
                'on our public leaderboard and transaction pages.',
              ),
              _P(
                'You have the option to control how your name is displayed via the settings on your account page.',
              ),

              const SizedBox(height: 20),
              _H2('Private Account Information'),
              _P(
                'When you create an account with us, we collect your email address. We use this email to send you '
                'important information about our services, such as confirmation of your account creation, instructions '
                'for resetting your password, and notifications about account deletion.',
              ),
              _P(
                'If you choose to sign up for our service directly on CBB Blue Chips, you\'ll create a password. '
                'Keep this password confidential to maintain the security of your account.',
              ),
              _P(
                'If you sign up using a third-party authentication provider (for example, Google Sign-In), you won\'t '
                'need to create a password for our service initially. However, you can choose to add a password to '
                'your account later.',
              ),
              _P(
                'When you sign in through a third-party provider, they might supply a profile image linked to your account. '
                'We don\'t store this image on our servers. It is only displayed alongside other private account information '
                'for your reference.',
              ),
              _P(
                'You are responsible for practicing good security habits with your sign-in information. This includes choosing '
                'strong passwords and keeping your login details confidential.',
              ),

              const SizedBox(height: 20),
              _H2('Use of your Personal Information'),
              _P(
                'CBB Blue Chips collects and uses your personal information to operate and deliver the services you have requested.',
              ),
              _P(
                'CBB Blue Chips may also use your personally identifiable information to inform you of other products or services available from CBB Blue Chips and its affiliates.',
              ),

              const SizedBox(height: 20),
              _H2('Sharing Information with Third Parties'),
              _P(
                'CBB Blue Chips does not sell, rent or lease its customer lists to third parties.',
              ),
              _P(
                'CBB Blue Chips may share data with trusted partners to help perform statistical analysis, send you email or postal mail, '
                'provide customer support, or arrange for deliveries. All such third parties are prohibited from using your personal information '
                'except to provide these services to CBB Blue Chips, and they are required to maintain the confidentiality of your information.',
              ),
              _P(
                'CBB Blue Chips may disclose your personal information, without notice, if required to do so by law or in the good faith belief that such action '
                'is necessary to: (a) conform to the edicts of the law or comply with legal process served on CBB Blue Chips or the site; '
                '(b) protect and defend the rights or property of CBB Blue Chips; and/or (c) act under exigent circumstances to protect the personal safety '
                'of users of CBB Blue Chips, or the public.',
              ),

              const SizedBox(height: 20),
              _H2('Automatically Collected Information'),
              _P(
                'Information about your computer hardware and software may be automatically collected by CBB Blue Chips. This information can include: '
                'your IP address, browser type, domain names, access times and referring website addresses. This information is used for the operation of the service, '
                'to maintain quality of the service, and to provide general statistics regarding use of the CBB Blue Chips website.',
              ),

              const SizedBox(height: 20),
              _H2('Use of Cookies'),
              _P(
                'The CBB Blue Chips website may use "cookies" to help you personalize your online experience. A cookie is a text file that is placed on your hard disk '
                'by a web page server. Cookies cannot be used to run programs or deliver viruses to your computer. Cookies are uniquely assigned to you, and can only be '
                'read by a web server in the domain that issued the cookie to you.',
              ),
              _P(
                'One of the primary purposes of cookies is to provide a convenience feature to save you time. The purpose of a cookie is to tell the Web server that '
                'you have returned to a specific page. For example, if you personalize CBB Blue Chips pages, or register with CBB Blue Chips site or services, a cookie '
                'helps CBB Blue Chips to recall your specific information on subsequent visits.',
              ),
              _P(
                'You have the ability to accept or decline cookies. Most Web browsers automatically accept cookies, but you can usually modify your browser setting to '
                'decline cookies if you prefer. If you choose to decline cookies, you may not be able to fully experience the interactive features of the CBB Blue Chips '
                'services or websites you visit.',
              ),

              const SizedBox(height: 20),
              _H2('Security of your Personal Information'),
              _P(
                'CBB Blue Chips secures your personal information from unauthorized access, use, or disclosure. CBB Blue Chips uses the following methods for this purpose:',
              ),
              const _BulletList(items: ['SSL Protocol']),
              _P(
                'When personal information (such as a credit card number) is transmitted to other websites, it is protected through the use of encryption, '
                'such as the Secure Sockets Layer (SSL) protocol.',
              ),
              _P(
                'We strive to take appropriate security measures to protect against unauthorized access to or alteration of your personal information. '
                'Unfortunately, no data transmission over the Internet or any wireless network can be guaranteed to be 100% secure. As a result, while we strive '
                'to protect your personal information, you acknowledge that there are security and privacy limitations inherent to the Internet which are beyond '
                'our control; and security, integrity, and privacy of any and all information and data exchanged between you and us through this Site cannot be guaranteed.',
              ),

              const SizedBox(height: 20),
              _H2('Right to Deletion'),
              _P(
                'Subject to certain exceptions set out below, on receipt of a verifiable request from you, we will:',
              ),
              const _BulletList(
                items: [
                  'Delete your personal information from our records; and',
                  'Direct any service providers to delete your personal information from their records.',
                ],
              ),
              _P(
                'Please note that we may not be able to comply with requests to delete your personal information if it is necessary to:',
              ),
              const _BulletList(
                items: [
                  'Complete the transaction for which the personal information was collected or otherwise perform a contract between you and us;',
                  'Detect security incidents, protect against malicious, deceptive, fraudulent, or illegal activity; or prosecute those responsible for that activity;',
                  'Debug to identify and repair errors that impair existing intended functionality;',
                  'Exercise free speech, ensure the right of another consumer to exercise their right of free speech, or exercise another right provided for by law;',
                  'Comply with the California Electronic Communications Privacy Act;',
                  'Engage in public or peer‑reviewed research, where deletion would seriously impair results (with informed consent);',
                  'Enable solely internal uses aligned with your relationship with us;',
                  'Comply with an existing legal obligation; or',
                  'Otherwise use your personal information, internally, in a lawful manner that is compatible with the context in which you provided the information.',
                ],
              ),

              const SizedBox(height: 20),
              _H2('Children Under Thirteen'),
              _P(
                'We do not knowingly collect personal information from children under 13 years of age. If we learn that we have inadvertently gathered personal data '
                'from children under 13, we will take reasonable measures to promptly delete such information from our records.',
              ),
              _P(
                'Our website and services are directed to people who are at least 13 years old or older. If you are a parent or guardian and believe we may have collected '
                'information from a child under the age of 13, please contact us immediately so we can take appropriate action.',
              ),

              const SizedBox(height: 20),
              _H2('Disconnecting your Account from Third Parties'),
              _P(
                'You will be able to connect your CBB Blue Chips account to third party accounts. By connecting, you acknowledge and agree that you are consenting to the '
                'continuous release of information about you to others (in accordance with your privacy settings on those third party sites). If you do not want information about you, '
                'including personally identifying information, to be shared in this manner, do not use this feature. You may disconnect or delete access to your accounts by visiting the '
                'account page or by contacting us via email.',
              ),

              const SizedBox(height: 20),
              _H2('E‑mail Communications'),
              _P(
                'From time to time, CBB Blue Chips may contact you via email for announcements, offers, alerts, confirmations, surveys, or other communication.',
              ),
              _P(
                'If you would like to stop receiving marketing or promotional communications via email from CBB Blue Chips, you may opt out by clicking unsubscribe at the bottom of the email.',
              ),

              const SizedBox(height: 20),
              _H2('External Data Storage Sites'),
              _P(
                'We may store your data on servers provided by third‑party hosting vendors with whom we have contracted.',
              ),

              const SizedBox(height: 20),
              _H2('Changes to this Statement'),
              _P(
                'CBB Blue Chips reserves the right to change this Privacy Policy from time to time. We will notify you about significant changes by sending a notice to the primary email address '
                'specified in your account, placing a prominent notice on our website, and/or updating privacy information. Your continued use after such modifications constitutes your '
                'acknowledgment and agreement to be bound by the Policy.',
              ),

              const SizedBox(height: 20),
              _H2('Contact Information'),
              _P(
                'If you have any questions about this Privacy Policy please contact us:',
              ),
              const LegalContactList(),
              _P('Effective as of $lastUpdated'),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsAndConditionsTab extends StatelessWidget {
  const _TermsAndConditionsTab();

  static const lastUpdated = 'March 15, 2024';

  @override
  Widget build(BuildContext context) {
    final body = Theme.of(context).textTheme.bodyMedium;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _H1('Terms and Conditions'),
              Text('Last updated: $lastUpdated', style: body),
              const SizedBox(height: 12),
              _P(
                'Please read these terms and conditions carefully before playing and continuing to CBB Blue Chips. '
                'By playing, you are agreeing to the terms and conditions laid before you.',
              ),
              _P(
                'The words with the initial letter capitalized have meanings defined under specific conditions.',
              ),

              const SizedBox(height: 20),
              _H2('Definitions'),
              const _BulletList(
                items: [
                  'Affiliate means an entity that controls, is controlled by, or is under common control with a party.',
                  'Country refers to: United States.',
                  'Company refers to CBB Blue Chips.',
                  'Device means any device that can access the Service such as a computer, a cellphone, or a digital tablet.',
                  'Service refers to the Website.',
                  'Third‑party Social Media Service means any services or content provided by a third‑party that may be displayed, included, or made available by the Service.',
                  'Website refers to CBB Blue Chips, accessible from the link provided.',
                  'You means the individual accessing or using the Service, or the company or other legal entity on whose behalf such individual is accessing or using the Service.',
                ],
              ),

              const SizedBox(height: 20),
              _H2('Acknowledgment'),
              _P(
                'These are the Terms and Conditions governing the use of this Service and the agreement between you and the Company. '
                'Your use of the Service is conditional upon accepting and complying with the Company\'s Privacy Policy.',
              ),
              _P(
                'By accessing or using the Service, you agree to be bound by these Terms and Conditions; if you disagree with any part, do not access the Service.',
              ),
              _P(
                'You represent that you are over the age of 13. The Company does not permit those under 13 to use the Service.',
              ),
              _P(
                'This Service is intended only for users located within the United States. By accessing or using the Service, you confirm that you are located in the United States.',
              ),
              _P(
                'Please read our Privacy Policy carefully before using the Service.',
              ),

              const SizedBox(height: 20),
              _H2('Account'),
              _P(
                'The points on this site are intended for gameplay purposes only and have no real monetary value.',
              ),
              const _BulletList(
                items: [
                  'Users must sign up with a valid email address.',
                  'Sign‑ups will close after the completion of the round of 64. Only one account is allowed per individual.',
                  'CBB Blue Chips reserves the right to close any account for any reason, including but not limited to: '
                      'cheating, harassment, spamming, vulgar/offensive names, IP infringement, legal violations, account sharing, or disrupting services.',
                ],
              ),

              const SizedBox(height: 20),
              _H2('Links to Other Websites'),
              _P(
                'The Service may contain links to third‑party websites or services that are not owned or controlled by the Company. '
                'The Company has no control over and assumes no responsibility for the content, privacy policies, or practices of any third‑party websites or services.',
              ),

              const SizedBox(height: 20),
              _H2('Termination'),
              _P(
                'We may terminate or suspend your access immediately, without prior notice or liability, for any reason whatsoever, including breach of these Terms.',
              ),
              _P(
                'Upon termination, your right to use the Service will cease immediately. Any trace of hacking or attempting to cheat will result in termination.',
              ),

              const SizedBox(height: 20),
              _H2('Limitation of Liability'),
              _P(
                'Notwithstanding any damages that you might incur, the entire liability of the Company and any of its suppliers under any provision of these Terms '
                'and your exclusive remedy shall be limited to the amount actually paid by you through the Service or 100 USD if you haven\'t purchased anything through the Service.',
              ),
              _P(
                'To the maximum extent permitted by applicable law, in no event shall the Company or its suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever.',
              ),

              const SizedBox(height: 20),
              _H2('"AS IS" and "AS AVAILABLE" Disclaimer'),
              _P(
                'The Service is provided to you "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind, to the maximum extent permitted under applicable law.',
              ),

              const SizedBox(height: 20),
              _H2('Governing Law'),
              _P(
                'The laws of the United States, excluding its conflicts of law rules, shall govern these Terms and your use of the Service. '
                'Your use may also be subject to other local, state, national, or international laws.',
              ),

              const SizedBox(height: 20),
              _H2('Disputes Resolution'),
              _P(
                'If you have any concern or dispute about the Service, you agree to first try to resolve the dispute informally by contacting the Company.',
              ),

              const SizedBox(height: 20),
              _H2('For European Union (EU) Users'),
              _P(
                'If you are a European Union consumer, you will benefit from any mandatory provisions of the law of the country in which you are resident.',
              ),

              const SizedBox(height: 20),
              _H2('United States Legal Compliance'),
              _P(
                'You represent and warrant that (i) you are not located in a country that is subject to the United States government embargo, '
                'or that has been designated by the United States government as a "terrorist supporting" country, and '
                '(ii) you are not listed on any United States government list of prohibited or restricted parties.',
              ),

              const SizedBox(height: 20),
              _H2('Severability and Waiver'),
              _P(
                'If any provision of these Terms is held to be unenforceable or invalid, such provision will be modified to achieve its objectives to the greatest extent possible.',
              ),

              const SizedBox(height: 20),
              _H2('Translation Interpretation'),
              _P(
                'If these Terms are translated, the original English text shall prevail in the case of a dispute.',
              ),

              const SizedBox(height: 20),
              _H2('Changes to These Terms and Conditions'),
              _P(
                'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. '
                'If a revision is material we will make reasonable efforts to provide at least 30 days\' notice prior to new terms taking effect.',
              ),

              const SizedBox(height: 20),
              _H2('Contact Information'),
              _P(
                'If you have any questions about these Terms and Conditions please contact us:',
              ),
              const LegalContactList(),
              _P('Effective as of $lastUpdated'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Typographic helpers

class _H1 extends StatelessWidget {
  final String text;
  const _H1(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _H2 extends StatelessWidget {
  final String text;
  const _H2(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _P extends StatelessWidget {
  final String text;
  const _P(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  const _BulletList({required this.items});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (t) => Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('•  '),
                  Expanded(child: Text(t, style: style)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class CBBInlineLink extends StatelessWidget {
  const CBBInlineLink({super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );
    return GestureDetector(
      onTap: () => launchUrlString(CBBLink.url),
      child: Text(CBBLink.displayText, style: style),
    );
  }
}
