import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/pages/found_item_info_page.dart';
import 'package:lost_items/pages/listing_page.dart';
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ItemListing()));
        },
        child: SvgPicture.string(
            """<svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 24 24"><g fill="none" stroke="white" stroke-linecap="round" stroke-linejoin="round" stroke-width="2"><path stroke-dasharray="2" stroke-dashoffset="2" d="M4 5h0.01"><animate fill="freeze" attributeName="stroke-dashoffset" dur="0.1s" values="2;0"/></path><path stroke-dasharray="14" stroke-dashoffset="14" d="M8 5h12"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.1s" dur="0.2s" values="14;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M4 10h0.01"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.3s" dur="0.1s" values="2;0"/></path><path stroke-dasharray="14" stroke-dashoffset="14" d="M8 10h12"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.4s" dur="0.2s" values="14;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M4 15h0.01"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.6s" dur="0.1s" values="2;0"/></path><path stroke-dasharray="14" stroke-dashoffset="14" d="M8 15h12"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.7s" dur="0.2s" values="14;0"/></path><path stroke-dasharray="2" stroke-dashoffset="2" d="M4 20h0.01"><animate fill="freeze" attributeName="stroke-dashoffset" begin="0.9s" dur="0.1s" values="2;0"/></path><path stroke-dasharray="14" stroke-dashoffset="14" d="M8 20h12"><animate fill="freeze" attributeName="stroke-dashoffset" begin="1s" dur="0.2s" values="14;0"/></path></g></svg>"""),
      ),
      body: AppPaddingWrapper(
        child: ExpandableScrollableWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gap(MediaQuery.paddingOf(context).top + 40),
              SvgPicture.asset("assets/logo_new.svg"),

              const Gap(31),
              Text("Hi ${AuthRepository.instance.username}.",
                  style: AppTheme.headerTextStyle, textAlign: TextAlign.center),
              const Gap(12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/wallet.svg"),
                  )
                  Text(""),
                ],
              ),
              const Gap(34),
              Column(
                children: [
                  _actionBuilder(
                      title: "Report a missing item",
                      onTap: () {
                        // itemFound(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FoundItemInfoPage(
                                      forLostItem: true,
                                    )));
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
