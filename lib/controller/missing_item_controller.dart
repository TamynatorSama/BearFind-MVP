import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:lost_items/controller/repository/missing_repository.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/pages/widget/item_found.dart';
import 'package:lost_items/pages/widget/looking_for_match.dart';
import 'package:lost_items/pages/widget/not_found.dart';
import 'package:lost_items/utils/app_theme.dart';
import 'package:lost_items/utils/sse_handler.dart';

MissingItemController missingController = MissingItemController();

class MissingItemController extends ChangeNotifier {
  StreamSubscription<SSEModel>? sseStream;
  Timer? timeout;
  bool outOfTime = false;
  LostItem? item;

  final MissingItemRepo _repo = MissingItemRepo();

  lookForItem(BuildContext context,
      {required String description,
      String? color,
      String? lastSeenLocation,
      String tip = "0",
      List<String> images = const []}) async {
    lookForMatch(context);
    await _repo
        .reportMissingItem(
            description: description,
            color: color,
            images: images,
            lastSeenLocation: lastSeenLocation,
            tip: tip.isEmpty ? "0" : tip)
        .then((value) {
      if (!value.status) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppTheme.primaryColor,
            content: Text(
              value.message,
              style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
            )));
        return;
      }

      if (value.status) {
        try {
          item = value.result!;
          timeout ??= Timer.periodic(const Duration(seconds: 1), (time) {
            if (time.tick > 10) {
              outOfTime = true;
              notifyListeners();
              itemNotFound(context,item: item!);
              close();
            }
          });
          Stream<SSEModel> stream =
              SseHandler().createConnection(itemID: item?.itemId ?? "");
          sseStream = stream.listen((data) => handleStream(data, callback: () {
                Navigator.pop(context);
                itemFound(context);
              }));
        } catch (e) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: AppTheme.primaryColor,
              content: Text(
                e.toString(),
                style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
              )));
        }
      }
    });
  }

  handleStream(SSEModel value, {Function()? callback}) {
    if (value.data != null) {
      final possibleJson = jsonDecode(value.data!);
      print(possibleJson);
      notifyListeners();
      item = LostItem.fromJson(possibleJson["data"]["item_info"]);
      if (possibleJson["data"]["is_found"] && sseStream != null) {
        callback?.call();
        close();
      }
    }
  }

  close() {
    if (sseStream != null) {
      sseStream!.cancel();
      SSEClient.unsubscribeFromSSE();
    }

    if (timeout != null) {
      timeout!.cancel();
    }
    sseStream = null;
    timeout = null;
  }
}
