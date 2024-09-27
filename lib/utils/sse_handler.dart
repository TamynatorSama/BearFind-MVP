import 'dart:async';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/utils/base_dio.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

class SseHandler {
  static SseHandler? _instance;

  factory SseHandler() {
    _instance ??= SseHandler._internal();
    return _instance!;
  }

  ///GET REQUEST
  ///
  Stream<SSEModel> createConnection({required String itemID}) {
    String url =
        "${BaseApi.instance.dio.options.baseUrl}/secure/search/$itemID";
    print(url);
    print("Bearer ${AuthRepository.instance.token}");
    print("asdasdsd");
    return SSEClient.subscribeToSSE(
        method: SSERequestType.POST,
        url: url,
        header: {
          "authorization": "Bearer ${AuthRepository.instance.token}",
          'app_id': '7d1b5fb2-0979-465a-82ef-2194da68600d',
          'Content-Type': "application/json"
        });
  }

  SseHandler._internal();
}
