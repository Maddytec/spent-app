import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const AdaptativeButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(label),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () => onPressed,
          )
        : ElevatedButton(
            child: Text(label),
            onPressed: () => onPressed,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ));
  }
}
