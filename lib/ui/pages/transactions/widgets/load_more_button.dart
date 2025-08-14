import 'package:flutter/material.dart';

class LoadMoreButton extends StatelessWidget {
  final VoidCallback onLoad;
  const LoadMoreButton({super.key, required this.onLoad});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onLoad,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text('Load more'),
      ),
    );
  }
}
