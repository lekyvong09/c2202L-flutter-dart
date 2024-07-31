

import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child; /// Icon
  final String value;
  final Color? color;

  const Badge({super.key, required this.child, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 6,
          top: 3,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Theme.of(context).colorScheme.secondary
            ),
            child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14,)
            ),
          ),
        )
      ],
    );
  }
}