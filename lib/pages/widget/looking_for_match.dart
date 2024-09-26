import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> lookForMatch(BuildContext context)async{
  return await showDialog(
    barrierDismissible: false,
    context: context, builder: (_)=>BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: 5,
      sigmaY: 5
    ),

    child: const Dialog(
      
      child: LookingForMatch(),
    ),
  ));
}

class LookingForMatch extends StatelessWidget {
  const LookingForMatch({super.key});

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
          Text("Finding  a match",style: AppTheme.bodyTextStyle2,),
          const Gap(24),
          CircularProgressIndicator(
            color: AppTheme.accentColor,
            strokeWidth: 3,
          )
        ],
      ),
    );
  }
}