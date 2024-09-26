import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_switch.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemNotFound(BuildContext context)async{
  return await showDialog(
    barrierDismissible: false,
    context: context, builder: (_)=>BackdropFilter(
    filter: ImageFilter.blur(
      sigmaX: 5,
      sigmaY: 5
    ),

    child: const Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.white,
      child: ItemNotFound(),
    ),
  ));
}

class ItemNotFound extends StatelessWidget {
  const ItemNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(),
          SvgPicture.asset("assets/cancel.svg"),
          const Gap(12),
          // update
          const Gap(24),
                    Text("We can’t find your item at the moment",textAlign: TextAlign.center,style: AppTheme.buttonTextStyle.copyWith(color: Colors.black),),
          const Gap(12),
          Text("Oppps... We would be on the look out. Toggle to receive notification as soon as we find your item.",textAlign: TextAlign.center,style: AppTheme.bodyTextStyle2,),
          const Gap(12),
         Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Push Notification",style: AppTheme.formTextStyle),
              const CustomSwitch(),
            ],
          ),
          const Gap(24),
          const CustomButton(text: "Done")
        ],
      ),
    );
  }
}


