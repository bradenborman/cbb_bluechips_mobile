import 'package:flutter/material.dart';

class UnableToLoadMessage extends StatelessWidget {
  final String text;
  const UnableToLoadMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
      ),
    );
  }
}
