import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/utils/app_theme.dart';

Future<bool?> itemFound(BuildContext context)async{
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
      child: ItemFound(),
    ),
  ));
}

class ItemFound extends StatelessWidget {
  const ItemFound({super.key});

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
          Text("Your Item has been found",style: AppTheme.buttonTextStyle.copyWith(color: Colors.black),),
          const Gap(24),
          // update
          const Gap(24),
          Text("Head over to the Campus Help desk . \nProvide code to recover this Item.",textAlign: TextAlign.center,style: AppTheme.bodyTextStyle2,),
          const Gap(12),
          _retrievalCode(title: "kjkbfzbgzibgrzhibvgibgb",),
          const Gap(24),
          _qrCode()
        ],
      ),
    );
  }
}

Widget _retrievalCode(
        {
        required String title,}) =>
    Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color:
              AppTheme.accentColorLight),
      child: Row(
        children: [
          
          Container(
            height: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color:
              Colors.white),
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


Widget _qrCode(
      ) =>
    Container(
      height: 48,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color:
              AppTheme.accentColorLight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          SvgPicture.asset("assets/qr.svg"),
          const Gap(10),
          Text(
            "Or Scan QR code",
            style: AppTheme.bodyTextStyle2.copyWith(color: AppTheme.accentColorDark),
          ),
        ],
      ),
    );
