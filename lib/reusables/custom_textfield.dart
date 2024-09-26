import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lost_items/utils/app_theme.dart';

class CustomTextfield extends StatefulWidget {
  final String? label;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String? hintText;
  final EdgeInsets? contentPadding;
  final GlobalKey<FormFieldState>? inputKey;
  final TextStyle? customTextStyle;
  final TextInputType? inputType;
  final double? suffixMaxWidth;
  final EdgeInsets? customSuffixPadding;
  final List<TextInputFormatter>? inputFormatter;
  final TextAlign textAlign;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool hasBorder;
  final bool hasExtraBorder;
  final double? suffixWidth;
  final bool isReadOnly;
  final InputDecoration inputDecoration;
  final Function()? onTap;
  final bool showFocus;
  final int? maxLine;
  final int? maxLength;
  final bool prefixBorders;
  final Color? fillColor;
  final bool hasDropdown;
  final Function(bool isFocused)? onFocusFunction;
  const CustomTextfield({
    super.key,
    this.label,
    this.hasExtraBorder = false,
    this.controller,
    this.suffixMaxWidth,
    this.fillColor,
    this.hasBorder = true,
    this.inputKey,
    this.maxLength,
    this.showFocus = true,
    this.isReadOnly = false,
    this.onTap,
    this.prefixBorders = false,
    this.suffixWidth,
    this.maxLine,
    this.customTextStyle,
    this.onChanged,
    this.hasDropdown = false,
    this.inputFormatter,
    this.textAlign = TextAlign.start,
    this.validator,
    this.suffixIcon,
    this.hintText,
    this.prefixIcon,
    this.customSuffixPadding,
    this.inputType,
    this.contentPadding,
    this.onFocusFunction,
    this.isPassword = false,
    this.inputDecoration = const InputDecoration(),
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  GlobalKey<FormFieldState>? _textFieldKey;

  @override
  void initState() {
    _textFieldKey = widget.inputKey ?? GlobalKey<FormFieldState>();
    super.initState();
  }

  bool isObscuredText = true;

  updateObscuredText() => setState(() {
        isObscuredText = !isObscuredText;
      });

  String? defaultValidator(String? value) {
    if ((value ?? "").isEmpty) {
      return "${widget.hintText ?? 'This'} field is required";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: _textFieldKey,
      obscureText: widget.isPassword ? isObscuredText : false,
      readOnly: widget.isReadOnly,
      textAlign: widget.textAlign,
      controller: widget.controller,
      onTap: widget.onTap,
      maxLines: widget.maxLine ?? 1,
      maxLength: widget.maxLength,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator ?? defaultValidator,
      inputFormatters: widget.inputFormatter,
      keyboardType: widget.inputType,
      onChanged: widget.onChanged,
      cursorColor: Theme.of(context).textTheme.bodyLarge?.color,
      decoration: widget.inputDecoration.copyWith(
        labelText: widget.label,
        labelStyle: AppTheme.bodyTextStyle2.copyWith(color:AppTheme.accentColorDark),
          hintText: widget.hintText,
          hintStyle: widget.customTextStyle ??
              AppTheme.formTextStyle
                  .copyWith(color:  AppTheme.accentColor),
          prefixIcon: widget.prefixIcon == null
              ? null
              : Container(
                  width: 55,
                  // height: 10,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: widget.prefixBorders
                          ? Border(
                              right: BorderSide(
                                  width: 2, color: AppTheme.accentColor))
                          : null),
                  child: widget.prefixIcon),
          suffixIcon: widget.isPassword
              ? Container(
                  padding: const EdgeInsets.all(14),
                  child: InkWell(
                      onTap: updateObscuredText,
                      child: SvgPicture.asset(
                        isObscuredText
                            ? "assets/svgs/eye_closed.svg"
                            : "assets/svgs/eye_open.svg",
                        width: 20,
                        height: 20,
                      )))
              : widget.suffixIcon == null
                  ? null
                  : Container(
                      constraints: BoxConstraints(
                          maxWidth: widget.suffixMaxWidth ?? 70),
                      alignment: Alignment.center,
                      margin: widget.hasDropdown? null:const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          border: !widget.hasExtraBorder? Border.all(width: 0,color: Colors.transparent):Border(
                              left: BorderSide(
                                  width: 1, color: AppTheme.accentColor))),
                      child: widget.suffixIcon),
          contentPadding: widget.contentPadding ??
              (widget.hasBorder
                  ? const EdgeInsets.symmetric(vertical: 10,)
                  : const EdgeInsets.all(0)),
          
          
      ),
      style: widget.customTextStyle ??
          AppTheme.formTextStyle
    );
  }
}
