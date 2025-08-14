import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final bool wrapped;
  const LoadingSpinner({super.key, this.wrapped = false});

  @override
  Widget build(BuildContext context) {
    final spinner = const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    );

    if (!wrapped) return spinner;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: spinner,
    );
  }
}
