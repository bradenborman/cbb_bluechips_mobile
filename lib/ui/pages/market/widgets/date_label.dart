import 'package:flutter/material.dart';

class DateLabel extends StatelessWidget {
  final DateTime? dateTime;
  final String fallback;
  const DateLabel({super.key, required this.dateTime, required this.fallback});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final text = dateTime == null ? fallback : _formatDateNoYear(dateTime!);
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: cs.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

String _formatDateNoYear(DateTime dt) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final m = months[dt.month - 1];
  final d = dt.day.toString().padLeft(2, '0');
  int hour = dt.hour;
  final ampm = hour >= 12 ? 'PM' : 'AM';
  hour = hour % 12;
  if (hour == 0) hour = 12;
  final minute = dt.minute.toString().padLeft(2, '0');
  return '$m $d,  $hour:$minute $ampm';
}
