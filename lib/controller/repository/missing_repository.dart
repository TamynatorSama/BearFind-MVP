import 'package:dio/dio.dart';
import 'package:lost_items/controller/repository/auth_repo.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/model/repository_result.dart';
import 'package:lost_items/utils/base_dio.dart';

class MissingItemRepo {
  Future<RepositoryResult<LostItem?>> reportMissingItem(
      {required String description,
      String? color,
      String? lastSeenLocation,
      String? tip,
      List<String> images = const []}) async {
    try {
      BaseApi.instance.dio.options.headers.putIfAbsent(
          "authorization", () => "Bearer ${AuthRepository.instance.token}");
      return await BaseApi.instance.dio.post("/secure/find-item", data: {
        "description": description,
        "other_description": color,
        "last_seen_location": lastSeenLocation,
        "tip": tip,
        "item_images": images
      }).then((value) {
        print(value.data);
        return RepositoryResult(
            message: value.data["message"] ?? "Authentication successful",
            status: true,
            result: LostItem.fromJson(value.data["data"]));
      });
    } on DioException catch (e) {
      print(e.response);
      return RepositoryResult(
          message: e.response?.data["message"] ?? "failed to process request",
          status: false,
          result: null);
    } catch (e) {
      print(e);
      return const RepositoryResult(
          message: "Failed to process request", status: false, result: null);
    }
  }
}
