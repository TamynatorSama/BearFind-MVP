import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_items/controller/missing_item_controller.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/controller/repository/found_item_repo.dart';
import 'package:lost_items/pages/widget/item_submitted.dart';
import 'package:lost_items/reusables/app_padding_wrapper.dart';
import 'package:lost_items/reusables/custom_btn.dart';
import 'package:lost_items/reusables/custom_textfield.dart';
import 'package:lost_items/utils/app_theme.dart';
import 'package:lost_items/utils/decimal_formatter.dart';
import 'package:lost_items/utils/image_upload_notifier.dart';

class FoundItemInfoPage extends StatefulWidget {
  final bool forLostItem;
  const FoundItemInfoPage({super.key, this.forLostItem = false});

  @override
  State<FoundItemInfoPage> createState() => _FoundItemInfoPageState();
}

class _FoundItemInfoPageState extends State<FoundItemInfoPage> {
  TimeOfDay timeOfDay = TimeOfDay.now();
  DateTime? dateFound;
  bool? incentive;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  late TextEditingController nameController;
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  TextEditingController tipController = TextEditingController();
  List<String> processedImages = [];
  List<XFile> selectedImages = [];

  @override
  initState() {
    nameController =
        TextEditingController(text: AuthRepository.instance.username);
    super.initState();
  }

  onTap(bool value) {
    // if (value == incentive) {
    //   incentive = null;
    // } else {
    incentive = value;
    // }
    setState(() {});
  }

  addImage() async {
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((value) {
      if (value != null) {
        selectedImages.add(value);
        imageUploader.uploadMultipleImagesNative(context,
            imageFiles: [value.path]).then((value) {
          processedImages = [...processedImages, ...value];
        });
        setState(() {});
      }
    });
  }

  removeImage(String file) {
    processedImages.remove(file);
    setState(() {});
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
                  key: _form,
                  child: ListView(
                    children: [
                      CustomTextfield(
                        label: "Name",
                        controller: nameController,
                        isReadOnly: true,
                      ),
                      // if (!widget.forLostItem) ...[
                      const Gap(26),
                      CustomTextfield(
                        label: "Describe your item",
                        controller: descriptionController,
                      ),
                      // ],
                      if (!widget.forLostItem) ...[
                        const Gap(26),
                        CustomTextfield(
                          label: "Location last seen",
                          controller: locationController,
                          validator: (val) => null,
                        ),
                      ],
                      if (!widget.forLostItem) ...[
                        const Gap(26),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "When did you  discover this item?",
                              style: AppTheme.bodyTextStyle2,
                            ),
                            const Gap(8),
                            _dateSelector(
                                onTap: () {
                                  showDatePicker(
                                          context: context,
                                          firstDate:
                                              DateTime(DateTime.now().year - 3),
                                          initialDate:
                                              dateFound ?? DateTime.now(),
                                          lastDate: DateTime.now())
                                      .then((value) {
                                    if (value != null) {
                                      dateFound = value;
                                      setState(() {});
                                    }
                                  });
                                },
                                date: dateFound ?? DateTime.now()),
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
                                      timeOfDay =
                                          timeOfDay.replacing(hour: value);
                                      setState(() {});
                                    },
                                    item: List.generate(
                                        12, (index) => index + 1))),
                            const Gap(20),
                            Expanded(
                                child: _popUpMenu<int>(
                                    value: timeOfDay.minute
                                        .toString()
                                        .padLeft(2, "0"),
                                    onChange: (value) {
                                      timeOfDay =
                                          timeOfDay.replacing(minute: value);
                                      setState(() {});
                                    },
                                    item: List.generate(60, (index) => index))),
                            const Gap(20),
                            Expanded(
                                child: _popUpMenu<String>(
                                    value: timeOfDay.period.name.toUpperCase(),
                                    onChange: (value) {
                                      if (value.toLowerCase() ==
                                          timeOfDay.period.name.toLowerCase())
                                        return;
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
                        widget.forLostItem
                            ? "Enter keywords to describe the item"
                            : "Enter keywords to describe the item(s) you found",
                        style: AppTheme.headerTextStyle2,
                      ),
                      const Gap(15),
                      CustomTextfield(
                        label: "Color",
                        controller: colorController,
                        validator: (val) => null,
                      ),
                      const Gap(26),
                      widget.forLostItem
                          ? CustomTextfield(
                              label: "Location last seen",
                              controller: locationController,
                              validator: (val) => null,
                            )
                          : CustomTextfield(
                              label: "Others",
                              controller: othersController,
                              validator: (val) => null,
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
                                select: () => onTap(true),
                                title: "Yes",
                                isSelected: incentive == true),
                            const Gap(17),
                            _optionSelector(
                                select: () => onTap(false),
                                title: "No",
                                isSelected: incentive == false),
                          ],
                        ),
                        if (incentive == true) ...[
                          const Gap(24),
                          CustomTextfield(
                            label: "Tip",
                            controller: tipController,
                            inputFormatter: [decimalFormatter],
                            inputType: TextInputType.number,
                          ),
                        ],
                        const Gap(48)
                      ],
                      Text(
                        "Upload images of your lost item ${widget.forLostItem ? "" : "*"}",
                        style: AppTheme.headerTextStyle2,
                      ),
                      const Gap(15),

                      AnimatedBuilder(
                        animation: imageUploader,
                        builder: (context, _) => processedImages.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      spacing: 10,
                                      children: [
                                        ...processedImages.map((e) =>
                                            _selectedImageHolder(
                                                filePath: e,
                                                onRemove: () =>
                                                    removeImage(e))),
                                        Row(
                                          children: [
                                            const Gap(10),
                                            InkWell(
                                                onTap:
                                                    imageUploader.percentage !=
                                                            0
                                                        ? null
                                                        : addImage,
                                                child: SvgPicture.asset(
                                                  "assets/plus1.svg",
                                                  colorFilter: imageUploader
                                                              .percentage !=
                                                          0
                                                      ? ColorFilter.mode(
                                                          AppTheme
                                                              .accentColorDark,
                                                          BlendMode.srcIn)
                                                      : null,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  if (imageUploader.percentage != 0) ...[
                                    const Gap(10),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                              maxWidth: 150),
                                          child: LinearProgressIndicator(
                                            color: Colors.black,
                                            backgroundColor:
                                                AppTheme.accentColor,
                                            value: imageUploader.percentage,
                                          )),
                                    )
                                  ]
                                ],
                              )
                            : _imageSelector(
                                onTap: imageUploader.percentage != 0
                                    ? null
                                    : addImage,
                                percentage: imageUploader.percentage),
                      ),

                      const Gap(48),
                      CustomButton(
                        text:
                            widget.forLostItem ? "Find item" : "Find the Owner",
                        // onTap: ()=>lookForMatch(context),
                        // onTap: ()=>itemFound(context),
                        onTap: () async {
                          if (!_form.currentState!.validate()) return;
                          if (widget.forLostItem) {
                            missingController.lookForItem(context,
                                description: descriptionController.text,
                                images: processedImages,
                                color: colorController.text,
                                lastSeenLocation: locationController.text,
                                tip: tipController.text);
                          } else {
                            if (processedImages.isEmpty) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: AppTheme.primaryColor,
                                      content: Text(
                                        "upload an image to continue",
                                        style: AppTheme.buttonTextStyle
                                            .copyWith(fontSize: 12),
                                      )));
                              return;
                            }
                            await FoundItemRepo()
                                .reportFoundItem(
                                    description: descriptionController.text,
                                    lastSeenLocation: locationController.text,
                                    images: processedImages,
                                    color: colorController.text,
                                    other: othersController.text,
                                    dateFound: (dateFound ?? DateTime.now())
                                        .copyWith(
                                            hour: timeOfDay.hour,
                                            minute: timeOfDay.minute))
                                .then((value) {
                              if (value.status) {
                                itemSubmitted(context, item: value.result!);
                                return;
                              }
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      backgroundColor: AppTheme.primaryColor,
                                      content: Text(
                                        value.message,
                                        style: AppTheme.buttonTextStyle
                                            .copyWith(fontSize: 12),
                                      )));
                            });
                          }
                        },
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

Widget _selectedImageHolder({required String filePath, Function()? onRemove}) =>
    Stack(
      alignment: Alignment.topRight,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 100,
            width: 100,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppTheme.accentColorLight,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      filePath,
                    ))),
          ),
        ),
        InkWell(onTap: onRemove, child: SvgPicture.asset("assets/cancel.svg"))
      ],
    );

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
          style: AppTheme.headerTextStyle2
              .copyWith(color: isSelected ? Colors.white : null),
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

Widget _imageSelector({Function()? onTap, double percentage = 0}) => InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      child: Container(
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
            percentage == 0
                ? Text(
                    "Upload images of your item",
                    style: AppTheme.bodyTextStyle2,
                  )
                : ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 150),
                    child: LinearProgressIndicator(
                      color: Colors.black,
                      backgroundColor: AppTheme.accentColor,
                      value: percentage,
                    ))
          ],
        ),
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
        // offset: const Offset(0, -40),
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
