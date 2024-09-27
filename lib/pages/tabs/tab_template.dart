import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:lost_items/controller/list_item_controller.dart';
import 'package:lost_items/model/item_model.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/pages/widget/input_code.dart';
import 'package:lost_items/pages/widget/item_found.dart';
import 'package:lost_items/reusables/expandable_scrollable_widget.dart';
import 'package:lost_items/utils/app_theme.dart';

class ItemTabTemplate extends StatefulWidget {
  final bool forFoundItem;
  const ItemTabTemplate({super.key, this.forFoundItem = true});

  @override
  State<ItemTabTemplate> createState() => _ItemTabTemplateState();
}

class _ItemTabTemplateState extends State<ItemTabTemplate> {
  late ScrollController listController;

  @override
  void initState() {
    listController = ScrollController()..addListener(paginationTrigger);
    super.initState();
  }

  paginationTrigger() async {
    if (listController.offset >= listController.position.maxScrollExtent - 50) {
      if (!listItemController.paginating) {
        await listItemController.fetchAllItems(context,
            forFoundItems: widget.forFoundItem, isRefresh: false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: listItemController,
        builder: (context, _) {
          List<Items> pendingModel = (widget.forFoundItem
                  ? listItemController.foundItems?.list
                  : listItemController.missingItems?.list) ??
              [];
          return pendingModel.isEmpty
              ? emptyBudget()
              : RefreshIndicator(
                  onRefresh: () async => await listItemController.fetchAllItems(
                      context,
                      forFoundItems: widget.forFoundItem,
                      isRefresh: false),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            padding: EdgeInsets.only(
                                top: 24,
                                bottom:
                                    MediaQuery.paddingOf(context).bottom + 10),
                            controller: listController,
                            physics: const ClampingScrollPhysics(),
                            separatorBuilder: (context, index) => const Gap(20),
                            itemCount: pendingModel.length,
                            itemBuilder: (context, index) => _list(context,
                                item: pendingModel[index],
                                forFoundItem: widget.forFoundItem)),
                      ),
                      if (listItemController.paginating)
                        Column(
                          children: [
                            const Gap(20),
                            SpinKitThreeBounce(
                              size: 20,
                              itemBuilder: (context, index) => CircleAvatar(
                                radius: 1,
                                backgroundColor: AppTheme.primaryColor,
                              ),
                            ),
                            const Gap(20),
                          ],
                        )
                    ],
                  ),
                );
        });
  }
}

Widget _list(BuildContext context,
        {required Items item, required bool forFoundItem}) =>
    InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        if ((item.canClaim || item.isFound) &&
            item.otherInfo.isClaimed == false) {
          if (item.isFound) {
            
            itemFound(context,
            fromList: true,
            code: item.claimCode,
                item: LostItem.fromOtherInfo(item.otherInfo));
          }else{
            inputCode(context, item: LostItem.fromOtherInfo(item.otherInfo));
          }
          
        }
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.otherInfo.description ?? "",
                  style: AppTheme.headerTextStyle2.copyWith(fontSize: 14),
                ),
                const Gap(3),
                Text(
                  DateFormat.yMMMEd()
                      .format(item.otherInfo.lastSeen ?? DateTime.now()),
                  style: AppTheme.buttonTextStyle
                      .copyWith(fontSize: 12, color: AppTheme.accentColor),
                ),
              ],
            ),
            if ((item.canClaim || item.isFound) &&
                item.otherInfo.isClaimed == false)
              Row(
                children: [
                  if (item.canClaim && item.otherInfo.isClaimed == false)
                    Text(
                      "claim",
                      style: AppTheme.buttonTextStyle
                          .copyWith(fontSize: 12, color: AppTheme.primaryColor),
                    ),
                  const Icon(Icons.keyboard_arrow_right_rounded),
                ],
              )
          ],
        ),
      ),
    );

Widget emptyBudget() => ExpandableScrollableWidget(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SvgPicture.asset("assets/empty-street.svg")],
      ),
    );
