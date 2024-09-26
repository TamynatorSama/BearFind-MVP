import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lost_items/pages/widget/item_found.dart';
import 'package:lost_items/reusables/app_padding_wrapper.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_textfield.dart';
import 'package:lost_items/utils/app_theme.dart';

class FoundItemInfoPage extends StatefulWidget {
  final bool forLostItem;
  const FoundItemInfoPage({super.key, this.forLostItem = false});

  @override
  State<FoundItemInfoPage> createState() => _FoundItemInfoPageState();
}

class _FoundItemInfoPageState extends State<FoundItemInfoPage> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  bool? incentive;

  onTap(bool value) {
    if (value == incentive) {
      incentive = null;
    } else {
      incentive = value;
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppPaddingWrapper(
        child: Column(
          children: [
            Gap(MediaQuery.paddingOf(context).top + 40),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                  child: Transform.rotate(
                      angle: pi,
                      child: const Icon(
                        Icons.arrow_right_alt_rounded,
                        size: 28,
                      )),
                ),
                const Spacer(
                  flex: 4,
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      widget.forLostItem
                          ? "I want to report a missing item"
                          : "I found an item",
                      style: AppTheme.headerTextStyle.copyWith(fontSize: 15),
                    )),
                const Spacer(
                  flex: 5,
                ),
              ],
            ),
            Expanded(
              child: Form(
                  child: ListView(
                children: [
                  const CustomTextfield(
                    label: "Name",
                  ),
                  // if (!widget.forLostItem) ...[
                    const Gap(26),
                    const CustomTextfield(
                      label: "Describe your item",
                    ),
                  // ],
                  if (!widget.forLostItem) ...[
                  const Gap(26),
                  const CustomTextfield(
                    label: "Location last seen",
                  ),
                  ],
                  if (!widget.forLostItem)
                  ...[const Gap(26),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "When did you  discover this item?",
                        style: AppTheme.bodyTextStyle2,
                      ),
                      const Gap(8),
                      _dateSelector(date: DateTime.now()),
                    ],
                  ),
                  const Gap(8),
                  Row(
                    children: [
                      Expanded(
                          child: _popUpMenu<int>(
                              value: timeOfDay
                                  .format(context)
                                  .split(":")
                                  .first
                                  .padLeft(2, "0"),
                              onChange: (value) {
                                timeOfDay = timeOfDay.replacing(hour: value);
                                setState(() {});
                              },
                              item: List.generate(12, (index) => index + 1))),
                      const Gap(20),
                      Expanded(
                          child: _popUpMenu<int>(
                              value:
                                  timeOfDay.minute.toString().padLeft(2, "0"),
                              onChange: (value) {
                                timeOfDay = timeOfDay.replacing(minute: value);
                                setState(() {});
                              },
                              item: List.generate(60, (index) => index))),
                      const Gap(20),
                      Expanded(
                          child: _popUpMenu<String>(
                              value: timeOfDay.period.name.toUpperCase(),
                              onChange: (value) {
                                timeOfDay = timeOfDay.replacing(
                                    hour: timeOfDay.hour +
                                        (value == "AM" ? -12 : 12));
                                setState(() {});
                              },
                              item: ["AM", "PM"])),
                    ],
                  ),
                  ],
                  const Gap(48),
                  Text(
                    widget.forLostItem?"Enter keywords to describe the item": "Enter keywords to describe the item(s) you found",
                    style: AppTheme.headerTextStyle2,
                  ),
                  const Gap(15),
                  const CustomTextfield(
                    label: "Colour",
                  ),
                  const Gap(26),
                  widget.forLostItem
                      ? const CustomTextfield(
                          label: "Location last seen",
                        )
                      : const CustomTextfield(
                          label: "Others",
                        ),
                  const Gap(48),
                  if (widget.forLostItem) ...[
                    Text(
                      "Do you want to tip as incentive?",
                      style: AppTheme.headerTextStyle2,
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        _optionSelector(
                          select: ()=>onTap(true),
                            title: "Yes", isSelected: incentive == true),
                        const Gap(17),
                        _optionSelector(
                          select: ()=>onTap(false),
                            title: "No", isSelected: incentive == false),
                      ],
                    ),
                    const Gap(48)
                  ],
                  Text(
                    "Upload images of your lost item",
                    style: AppTheme.headerTextStyle2,
                  ),
                  const Gap(15),
                  _imageSelector(),
                  const Gap(48),
                  CustomButton(text: widget.forLostItem?"Find item": "Find the Owner",
                  // onTap: ()=>lookForMatch(context),
                  onTap: ()=>itemFound(context),
                  ),
                  Gap(MediaQuery.paddingOf(context).bottom + 20)
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _optionSelector(
        {bool isSelected = false,
        required String title,
        required Function() select}) =>
    InkWell(
      onTap: select,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: Container(
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: ShapeDecoration(
            shape: const StadiumBorder(),
            color:
                isSelected ? AppTheme.primaryColor : AppTheme.accentColorLight),
        child: Text(
          title,
          style: AppTheme.headerTextStyle2.copyWith(color: isSelected?Colors.white:null),
        ),
      ),
    );

Widget imagePlaceHolder() => Container(
    padding: const EdgeInsets.all(8),
    decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 5,
            color: Color(0xfff3f3f3),
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        color: Colors.white,
        shadows: [
          BoxShadow(
              blurRadius: 4,
              offset: const Offset(0, 1),
              color: const Color(0xff5e5e5e).withOpacity(0.25))
        ]),
    child: SvgPicture.asset(
      "assets/image.svg",
      width: 22,
    ));

Widget _imageSelector() => Container(
      width: double.maxFinite,
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          color: AppTheme.accentColorLight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Transform.translate(
                  offset: const Offset(-30, -15),
                  child: Transform.rotate(
                    angle: 90,
                    child: imagePlaceHolder(),
                  )),
              imagePlaceHolder(),
            ],
          ),
          const Gap(10),
          Text(
            "Upload images of your item",
            style: AppTheme.bodyTextStyle2,
          )
        ],
      ),
    );

Widget _dateSelector({required DateTime date, Function()? onTap}) => InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: AppTheme.accentColorLight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat.yMMMEd().format(date),
              style: AppTheme.headerTextStyle.copyWith(fontSize: 15),
            ),
            SvgPicture.asset("assets/date.svg")
          ],
        ),
      ),
    );

Widget _popUpMenu<T>(
        {List<T> item = const [],
        Function(T value)? onChange,
        required String value}) =>
    PopupMenuButton<T>(
        color: Colors.white,
        constraints: const BoxConstraints(
          maxHeight: 200,
          minWidth: 2.0 * 56.0,
          maxWidth: 5.0 * 56.0,
        ),
        position: PopupMenuPosition.under,
        offset: const Offset(0, -40),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppTheme.accentColorLight),
          child: Row(
            children: [
              const Spacer(),
              Align(
                alignment: AlignmentDirectional.center,
                child: Text(
                  value,
                  style: AppTheme.headerTextStyle.copyWith(fontSize: 15),
                ),
              ),
              const Spacer(),
              const Column(
                children: [
                  Icon(Icons.arrow_drop_up_rounded),
                  Icon(Icons.arrow_drop_down_rounded),
                ],
              )
            ],
          ),
        ),
        itemBuilder: (context) {
          return item
              .map((e) => PopupMenuItem<T>(
                  onTap: () => onChange?.call(e),
                  child: Text(e.runtimeType.toString() == "int"
                      ? e.toString().padLeft(2, "0")
                      : e.toString())))
              .toList();
        });
