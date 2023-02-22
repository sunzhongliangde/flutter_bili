import 'package:flutter/material.dart';

import '../util/color.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback? onPress;

  const LoginButton(
      {super.key, required this.title, required this.enable, this.onPress});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)
        ),
        height: 45, 
        disabledColor: primary[50],
        color: primary,
        child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16),),
        onPressed: () {
          if (onPress != null) {
            onPress!();
          }
        },
      ),
    );
  }
}
