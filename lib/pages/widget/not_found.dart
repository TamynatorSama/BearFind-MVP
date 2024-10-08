import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/controller/missing_item_controller.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_switch.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemNotFound(BuildContext context,
    {required LostItem item, bool fromList = false}) async {
  return await showAnimatedDialog(
      barrierDismissible: false,
      context: context,
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      builder: (_) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => fromList
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
                  child: ItemNotFound(
                    fromList: fromList,
                    item: item,
                  ),
                ),
              ),
            ),
      ));
}

class ItemNotFound extends StatelessWidget {
  final LostItem item;
  final bool fromList;
  const ItemNotFound({super.key, required this.item, this.fromList = false});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) {
        missingController.close();
      },
      child: Padding(
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
            CustomButton(
              text: "Done",
              onTap: () {
                if (fromList) {
                  Navigator.pop(context);
                  return;
                }
                Navigator.popUntil(
                    context, (settings) => Navigator.canPop(context) == false);
              },
            )
          ],
        ),
      ),
    );
  }
}
