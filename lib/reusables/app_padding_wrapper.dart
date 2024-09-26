import 'package:flutter/material.dart';

class AppPaddingWrapper extends StatelessWidget {
  final Widget child;
  const AppPaddingWrapper({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal:
                (MediaQuery.sizeOf(context).width * 0.08).clamp(24, 48)),child: child,);
  }
}
