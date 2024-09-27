import 'package:dio/dio.dart';
import 'package:lost_items/model/lost_item_model.dart';
import 'package:lost_items/model/repository_result.dart';
import 'package:lost_items/utils/base_dio.dart';

class FoundItemRepo {
  Future<RepositoryResult<LostItem?>> reportFoundItem(
      {required String description,
      String? color,
      String? other,
      String? lastSeenLocation,
      DateTime? dateFound,
      List<String> images = const []}) async {
    try {
      print("asds");
      return await BaseApi.instance.dio.post("/login", data: {
        "description": description,
        "other_description": other,
        "color": color,
        "last_seen": dateFound?.toIso8601String(),
        "last_seen_location": lastSeenLocation,
        "item_images": images,
      }).then((value) {
        return RepositoryResult(
            message: value.data["message"] ?? "Authentication successful",
            status: true,
            result: LostItem.fromJson(value.data["data"]));
      });
    } on DioException catch (e) {
      return RepositoryResult(
          message: e.response?.data["message"] ?? "failed to process request",
          status: false,
          result: null);
    } catch (e) {
      return const RepositoryResult(
          message: "Failed to process request", status: false, result: null);
    }
  }
}
