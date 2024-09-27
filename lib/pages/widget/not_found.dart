import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_switch.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemNotFound(BuildContext context,
    {required LostItem item}) async {
  return await showAnimatedDialog(
      barrierDismissible: false,
      context: context,
      animationType: DialogTransitionType.size,
  curve: Curves.fastOutSlowIn,
  duration: const Duration(seconds: 1),
      builder: (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child:  Dialog(
              
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              backgroundColor: Colors.white,
              child: ItemNotFound(item: item,),
            ),
          ));
          
}

class ItemNotFound extends StatelessWidget {
  final LostItem item;
  const ItemNotFound({super.key,required this.item});

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
          
          if (item.itemImages.isNotEmpty) ...[
            const Gap(12),
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: AppTheme.accentColorLight,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        item.itemImages.first,
                      ))),
            ),
          ],
          
          const Gap(24),
          Text(
            "We can’t find your item at the moment",
            textAlign: TextAlign.center,
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.black),
          ),
          const Gap(12),
          Text(
            "Oppps... We would be on the look out. Toggle to receive notification as soon as we find your item.",
            textAlign: TextAlign.center,
            style: AppTheme.bodyTextStyle2,
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Push Notification", style: AppTheme.formTextStyle),
              const CustomSwitch(),
            ],
          ),
          const Gap(24),
          CustomButton(text: "Done",onTap: (){
            Navigator.popUntil(
                  context, (settings) => Navigator.canPop(context) == false);
          },)
        ],
      ),
    );
  }
}
