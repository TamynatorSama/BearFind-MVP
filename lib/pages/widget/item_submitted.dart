import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemSubmitted(BuildContext context,
    {required LostItem item,
    bool forThanks = false,
    bool forList = false}) async {
  return await showAnimatedDialog(
      barrierDismissible: false,
      animationType: DialogTransitionType.rotate3D,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
      builder: (_) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => forList
                ? Navigator.pop(context)
                : Navigator.popUntil(
                    context, (settings) => Navigator.canPop(context) == false),
        child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () {},
                child: Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: Colors.white,
                  child: ItemFound(
                    item: item,
                    forList: forList,
                    forThanks: forThanks,
                  ),
                ),
              ),
            ),
      ));
}

class ItemFound extends StatelessWidget {
  final LostItem item;
  final bool forThanks;
  final bool forList;
  const ItemFound(
      {super.key,
      required this.item,
      this.forThanks = false,
      this.forList = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Row(),
          SvgPicture.asset("assets/check.svg"),
          const Gap(12),
          Text(
            forThanks ? "Owner has been found" : "Item has been Submitted",
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.black),
          ),
          if (item.itemImages.isNotEmpty) ...[
            const Gap(24),
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
            forThanks
                ? "Thanks for Helping!"
                : "Thanks for being helpful.We hope to find the owner soon  enough. ",
            textAlign: TextAlign.center,
            style: AppTheme.bodyTextStyle2,
          ),
          const Gap(12),
          CustomButton(
            text: "Done",
            onTap: () {
             if (forList) {
                Navigator.pop(context);
                return;
              }
              Navigator.popUntil(
                  context, (settings) => Navigator.canPop(context) == false);
            },
          )
        ],
      ),
    );
  }
}
