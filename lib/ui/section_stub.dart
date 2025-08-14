import 'package:flutter/material.dart';
import 'section_header.dart';

class SectionStub extends StatelessWidget {
  final String title;
  const SectionStub({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SectionHeader(title: title),
        const SizedBox(height: 12),
        Text(
          '$title screen coming soon',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
