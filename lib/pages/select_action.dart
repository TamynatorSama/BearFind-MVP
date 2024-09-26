import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/pages/found_item_info_page.dart';
import 'package:lost_items/reusables/app_padding_wrapper.dart';
import 'package:lost_items/reusables/expandable_scrollable_widget.dart';
import 'package:lost_items/utils/app_theme.dart';

class ActionSelector extends StatefulWidget {
  const ActionSelector({super.key});

  @override
  State<ActionSelector> createState() => _ActionSelectorState();
}

class _ActionSelectorState extends State<ActionSelector> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppPaddingWrapper(
        child: ExpandableScrollableWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(MediaQuery.paddingOf(context).top + 40),
              SvgPicture.asset("assets/logo_new.svg"),
              const Gap(31),
              Text("Hi Josh.",
                  style: AppTheme.headerTextStyle, textAlign: TextAlign.center),
              const Gap(34),
              Column(
                children: [
                  _actionBuilder(title: "Report a missing item",onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FoundItemInfoPage(forLostItem: true,)));
                      }),
                  const Gap(24),
                  _actionBuilder(
                      title: "I found a missing item",
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const FoundItemInfoPage()));
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget _actionBuilder({required String title, Function()? onTap}) => InkWell(
  onTap: onTap,
  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
  child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(15),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: AppTheme.accentColorLight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTheme.headerTextStyle.copyWith(fontSize: 15),
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 26,
            )
          ],
        ),
      ),
);


