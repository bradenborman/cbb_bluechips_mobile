import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  static const route = '/support';
  const SupportPage({super.key});

  Future<void> _launchEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'support@cbbbluechips.com',
      query: Uri.encodeFull('subject=Support Request'),
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchFacebookGroup() async {
    const fbUrl = 'https://www.facebook.com/groups/cbbbluechips';
    final uri = Uri.parse(fbUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Need help?',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'If you experience any issues with CBB Blue Chips, please email us at:',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _launchEmail,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'support@cbbbluechips.com',
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Ask the community',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Join our official Facebook group to connect with other players, ask questions, and share strategies.',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _launchFacebookGroup,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.group, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'Join the CBB Blue Chips Facebook Group',
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'We aim to respond within 1–2 business days.',
                  style: textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
