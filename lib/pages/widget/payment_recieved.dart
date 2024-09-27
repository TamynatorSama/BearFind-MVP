import 'dart:ui';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> paymentReceived(BuildContext context,
    {required double amount}) async {
  return await showAnimatedDialog(
      barrierDismissible: true,
      animationType: DialogTransitionType.scale,
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 500),
      context: context,
      builder: (_) => GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => 
                 Navigator.pop(context)
                ,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: GestureDetector(
                onTap: () {},
                child: Dialog(
                  insetPadding: const EdgeInsets.symmetric(horizontal: 24),
                  backgroundColor: Colors.white,
                  child: PaymentReceived(
                    amount: amount,
                  ),
                ),
              ),
            ),
          ));
}

class PaymentReceived extends StatelessWidget {
  
  final double? amount;
  const PaymentReceived({super.key,this.amount});

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
            "Payment Received",
            style: AppTheme.buttonTextStyle.copyWith(color: Colors.black),
          ),
          const Gap(24),
          Text("\$ $amount",style: AppTheme.headerTextStyle.copyWith(fontSize: 32),),
          const Gap(24),
          CustomButton(
            text: "Done",onTap: ()=>Navigator.popUntil(
                  context, (settings) => Navigator.canPop(context) == false),)
        ],
      ),
    );
  }
}

