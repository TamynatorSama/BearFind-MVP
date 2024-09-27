import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemFound(BuildContext context,
    {required LostItem item, bool fromList = false, String? code}) async {
  return await showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.rotate3D,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
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
                  child: ItemFound(
                    item: item,
                    code: code,
                  ),
                ),
              ),
            ),
          ));
}

class ItemFound extends StatelessWidget {
  final LostItem item;
  final String? code;
  const ItemFound({super.key, required this.item,this.code});

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
            "Your Item has been found",
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
            "Head over to the Campus Help desk . \nProvide code to recover this Item.",
            textAlign: TextAlign.center,
            style: AppTheme.bodyTextStyle2,
          ),
          const Gap(12),
          _retrievalCode(
            context,
            title: code ?? item.itemId,
          ),
          const Gap(24),
          _qrCode()
        ],
      ),
    );
  }
}

Widget _retrievalCode(
  BuildContext context, {
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
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: title));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: AppTheme.primaryColor,
                  content: Text(
                    "item ID copied successfully",
                    style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
                  )));
            },
            child: Container(
              height: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white),
              child: SvgPicture.asset("assets/copy.svg"),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
