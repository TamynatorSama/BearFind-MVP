import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';
import 'package:lost_items/controller/list_item_controller.dart';
import 'package:lost_items/pages/tabs/tab_template.dart';
import 'package:lost_items/reusables/app_padding_wrapper.dart';
import 'package:lost_items/utils/app_theme.dart';

class ItemListing extends StatefulWidget {
  const ItemListing({super.key});

  @override
  State<ItemListing> createState() => _ItemListingState();
}

class _ItemListingState extends State<ItemListing>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isLoading = false;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    SchedulerBinding.instance.addPostFrameCallback((_) async{
      if (listItemController.foundItems != null) {
        isLoading = true;
        setState(() {});
      }
      await Future.wait([
        listItemController.fetchAllItems(context),
        listItemController.fetchAllItems(context, forFoundItems: false),
      ]);
      isLoading = false;
        setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AppPaddingWrapper(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(MediaQuery.paddingOf(context).top + 40),
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
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(5),
              height: 45,
              width: double.maxFinite,
              decoration: BoxDecoration(
                  color: AppTheme.accentColorLight,
                  borderRadius: BorderRadius.circular(6)),
              child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: Colors.white),
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium!
                      .copyWith(color: AppTheme.accentColorDark),
                  indicator: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  controller: tabController,
                  tabs: const [
                    Tab(
                      text: "Missing Items",
                    ),
                    Tab(
                      text: "Reported items",
                    ),
                  ]),
            ),
            Expanded(
              child: isLoading
                ? Center(
                  child: SpinKitThreeBounce(
                      size: 30,
                      itemBuilder: (context, index) => CircleAvatar(
                        radius: 5,
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                ): TabBarView(controller: tabController, children: const [
                ItemTabTemplate(
                  forFoundItem: false,
                ),
                ItemTabTemplate(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
