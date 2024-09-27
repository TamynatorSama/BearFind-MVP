import 'package:flutter/material.dart';
import 'package:lost_items/controller/repository/found_item_repo.dart';
import 'package:lost_items/model/item_model.dart';
import 'package:lost_items/model/list_model.dart';
import 'package:lost_items/utils/app_theme.dart';

ListItemController listItemController = ListItemController();

class ListItemController extends ChangeNotifier {
  final FoundItemRepo repo = FoundItemRepo();
  ListData<Items>? foundItems;
  ListData<Items>? missingItems;
  bool paginating = false;

  Future<void> fetchAllItems(BuildContext context,
      {
      bool isRefresh = true,
      bool forFoundItems = true}) async {
    int page = 0;
    ListData? cacheData;
    if (forFoundItems) {
      cacheData = foundItems;
    } else {
      cacheData = missingItems;
    }

    if (cacheData == null || isRefresh) {
      page = 1;
    } else {
      page = cacheData.model.currentPage + 1;
    }
    if (cacheData != null && !isRefresh) {
      if (cacheData.model.currentPage == cacheData.model.totalPages) {
        return;
      }
    }
    if (!isRefresh) {
      paginating = true;
      notifyListeners();
    }

    final result =
        await repo.getAllFoundItems(page: page, forFoundItems: forFoundItems);
    paginating = false;
    notifyListeners();

    if (result.status) {
      // _valueController.allBudgets.value = result.data["budget"];
      if (forFoundItems) {
        foundItems = isRefresh
            ? result.result
            : ListData(
                list: [...?foundItems?.list, ...?result.result?.list],
                model: result.result!.model);
      } else {
        missingItems = isRefresh
            ? result.result
            : ListData(
                list: [...?missingItems?.list, ...?result.result?.list],
                model: result.result!.model);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppTheme.primaryColor,
          content: Text(
            result.message,
            style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
          )));
    }
  }
}
