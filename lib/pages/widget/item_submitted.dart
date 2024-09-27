import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemSubmitted(BuildContext context,
    {required LostItem item}) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 24),
              backgroundColor: Colors.white,
              child: ItemFound(item: item,),
            ),
          ));
}

class ItemFound extends StatelessWidget {
  final LostItem item;
  const ItemFound({super.key, required this.item});

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
            "Item has been Submitted",
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
            "Thanks for being helpful.We hope to find the owner soon  enough. ",
            textAlign: TextAlign.center,
            style: AppTheme.bodyTextStyle2,
          ),
          const Gap(12),
          CustomButton(
            text: "Done",
            onTap: () {
              Navigator.popUntil(
                  context, (settings) => Navigator.canPop(context) == false);
            },
          )
        ],
      ),
    );
  }
}

Widget _retrievalCode({
  required String title,
}) =>
    Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: AppTheme.accentColorLight),
      child: Row(
        children: [
          Container(
            height: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Colors.white),
            child: SvgPicture.asset("assets/copy.svg"),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTheme.formTextStyle,
            ),
          ),
        ],
      ),
    );

Widget _qrCode() => Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: AppTheme.accentColorLight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/qr.svg"),
          const Gap(10),
          Text(
            "Or Scan QR code",
            style: AppTheme.bodyTextStyle2
                .copyWith(color: AppTheme.accentColorDark),
          ),
        ],
      ),
    );
