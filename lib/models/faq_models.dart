// lib/models/faq_models.dart
import 'package:flutter/foundation.dart';

enum FaqTipType { info, warning }

class FaqTip {
  final FaqTipType type;
  final String text;
  const FaqTip({required this.type, required this.text});
}

abstract class FaqLine {
  const FaqLine();
}

class FaqTextLine extends FaqLine {
  final String text;
  const FaqTextLine(this.text);
}

class FaqLinkLine extends FaqLine {
  final String before;
  final String linkText;
  final String link;
  final String after;
  const FaqLinkLine({
    required this.before,
    required this.linkText,
    required this.link,
    this.after = '',
  });
}

class Faq {
  final String question;
  final List<FaqLine> answer;
  final FaqTip? tip;
  const Faq({required this.question, required this.answer, this.tip});
}
