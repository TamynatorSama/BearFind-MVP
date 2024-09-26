import 'package:dio/dio.dart';
import 'package:lost_items/model/repository_result.dart';
import 'package:lost_items/utils/base_dio.dart';

class AuthRepository {
  static Future<RepositoryResult<List>> login(
      {required String email,
      String deviceToken = "testing",
      String deviceInfo = "testing"}) async {
    try {
      print(BaseApi.instance.dio.options.baseUrl);
      await BaseApi.instance.dio.post("/login", data: {
        "email": email,
        "device_token": deviceToken,
        "device_info": deviceToken
      });
      return const RepositoryResult(
          message: "success", status: true, result: []);
    } on DioException catch (e) {
      print(e.response);
      return const RepositoryResult(
          message: "failed", status: false, result: []);
    } catch (e) {
      return const RepositoryResult(
          message: "failed", status: false, result: []);
    }
  }
}
