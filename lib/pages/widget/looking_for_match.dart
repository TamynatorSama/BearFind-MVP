import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> lookForMatch(BuildContext context) async {
  return await showAnimatedDialog(
      // barrierDismissible: false,
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
      builder: (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: const Dialog(
              child: LookingForMatch(),
            ),
          ));
}

class LookingForMatch extends StatefulWidget {
  const LookingForMatch({super.key});

  @override
  State<LookingForMatch> createState() => _LookingForMatchState();
}

class _LookingForMatchState extends State<LookingForMatch> {
  double scale = 1.5;
  @override
  void initState() {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
                      
    //   scale = 1.3;    
    //   setState(() {});
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/search.png"),
          const Gap(24),
          Text(
            "Finding  a match",
                style: AppTheme.bodyTextStyle2,
              ),
            Gap(24),
            CircularProgressIndicator(
                color: AppTheme.accentColor,
            strokeWidth: 3,
          )
        ],
      ),
    );
  }
}
    