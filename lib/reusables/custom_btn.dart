import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/utils/app_theme.dart';

class CustomButton extends StatefulWidget {
  final void Function()? onTap;
  final String text;
  final bool isLoading;
  final String? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final Border? customBorder;
  final bool isDisactivated;
  final double? iconSpacing;
  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.iconSpacing,
    this.customBorder,
    this.icon,
    this.width,
    this.isLoading = false,
    this.isDisactivated = false,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.isDisactivated) return;
        FocusScope.of(context).unfocus();
        tapped = false;
        setState(() {});
        if (widget.onTap == null) return;

        widget.onTap!();
      },
      onTapDown: (details) {
        tapped = true;
        setState(() {});
      },
      onTapCancel: () {
        tapped = false;
        setState(() {});
      },
      child: AnimatedScale(
        scale: tapped ? 0.98 : 1,
        duration: const Duration(milliseconds: 300),
        child: IntrinsicWidth(
          child: Container(
            clipBehavior: Clip.hardEdge,
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 0),
            height: 49,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
                shape: const StadiumBorder(),
                color: widget.isDisactivated
                    ? AppTheme.accentColorDark
                    : widget.backgroundColor ?? AppTheme.primaryColor),
            child: widget.isLoading
                ? SpinKitThreeBounce(
                    size: 20,
                    itemBuilder: (context, index) => const CircleAvatar(
                      radius: 1,
                      backgroundColor: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(widget.text,
                          style: AppTheme.buttonTextStyle
                              .copyWith(color: widget.textColor)),
                      if (widget.icon != null) ...[
                        Gap(widget.iconSpacing ?? 5),
                        SvgPicture.asset(
                          widget.icon!,
                          colorFilter: ColorFilter.mode(
                              widget.textColor ?? Colors.white,
                              BlendMode.srcIn),
                          width: 17,
                        )
                      ]
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
