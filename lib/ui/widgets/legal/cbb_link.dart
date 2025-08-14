import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CBBLink extends StatelessWidget {
  const CBBLink({super.key});

  static const String url = 'https://www.cbbbluechips.com';
  static const String displayText = 'cbbbluechips.com';

  @override
  Widget build(BuildContext context) {
    final linkStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return InkWell(
      onTap: () => launchUrlString(url),
      child: Text(displayText, style: linkStyle),
    );
  }
}