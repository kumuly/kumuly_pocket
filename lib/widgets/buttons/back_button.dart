import 'dart:io';

import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
      onPressed: onPressed,
    );
  }
}
