import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/controller/repository/found_item_repo.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/pages/widget/item_submitted.dart';
import 'package:lost_items/pages/widget/payment_recieved.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_textfield.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> inputCode(BuildContext context, {required LostItem item}) async {
  return await showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.rotate3D,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
      builder: (_) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => Navigator.pop(context),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () {},
                child: Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: Colors.white,
                  child: InputClaimCode(
                    item: item,
                  ),
                ),
              ),
            ),
          ));
}

class InputClaimCode extends StatefulWidget {
  final LostItem item;
  const InputClaimCode({super.key, required this.item});

  @override
  State<InputClaimCode> createState() => _InputClaimCodeState();
}

class _InputClaimCodeState extends State<InputClaimCode> {
  TextEditingController codeController = TextEditingController();
  bool activateButton = false;

  @override
  void initState() {
    codeController.addListener(updateBtn);
    super.initState();
  }

  updateBtn() {
    if (codeController.text.trim().length < 5) {
      activateButton = false;
    } else {
      activateButton = true;
    }
    setState(() {});
  }

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
            "Owner has been found",
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.black),
          ),
          if (widget.item.itemImages.isNotEmpty) ...[
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
                        widget.item.itemImages.first,
                      ))),
            ),
          ],
          const Gap(24),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Input the claim code",
              textAlign: TextAlign.center,
              style: AppTheme.bodyTextStyle2,
            ),
          ),
          const Gap(12),
          CustomTextfield(
            customTextStyle: AppTheme.headerTextStyle
                .copyWith(fontSize: 24, fontWeight: FontWeight.w500),
            fillColor: AppTheme.accentColor,
            textAlign: TextAlign.center,
            controller: codeController,
            validator: (p0) => null,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            inputDecoration: InputDecoration(
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide.none),
            ),
          ),
          const Gap(24),
          CustomButton(
            text: "Continue",
            isDisactivated: !activateButton,
            onTap: () async {
              await FoundItemRepo()
                  .claimCode(
                      claimCode: codeController.text,
                      itemID: widget.item.itemId)
                  .then((value) {
                if (value.status) {
                  if (value.result?["has_tip"] == true) {
                    AuthRepository.instance.walletAmount =AuthRepository.instance.walletAmount ?? 0 +  double.parse((value.result?["amount"]??0));
                    paymentReceived(context, amount: double.parse((value.result?["amount"]??0).toString()));
                  } else {
                    itemSubmitted(context, item: widget.item, forThanks: true);
                  }
                  return;
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppTheme.primaryColor,
                    content: Text(
                      value.message,
                      style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
                    )));
              });
            },
          )
        ],
      ),
    );
  }
}
