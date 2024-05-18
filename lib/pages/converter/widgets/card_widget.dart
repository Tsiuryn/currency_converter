import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Widget child;
  const CardWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: child,
        ),
      ),
    );
  }
}
