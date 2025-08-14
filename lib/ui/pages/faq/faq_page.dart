import 'package:flutter/material.dart';

import '../../dotted_background.dart';
import '../../../theme.dart';

import 'faq_data.dart';
import 'widgets/faq_item.dart';

class FAQPage extends StatelessWidget {
  static const route = '/faq';
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBackground(
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: AppBar(title: const Text('FAQ')),
        body: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) => FaqItem(faq: faqs[index]),
        ),
      ),
    );
  }
}