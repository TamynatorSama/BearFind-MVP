import 'package:dio/dio.dart';
import 'package:lost_items/model/repository_result.dart';
import 'package:lost_items/utils/base_dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  String _username = "";
  String _token = "";
  late SharedPreferences _preferences;

  AuthRepository._privateConstructor();

  // Static final instance
  static final AuthRepository _instance = AuthRepository._privateConstructor();

  // Static method
  static AuthRepository get instance {
    return _instance;
  }

  String get token => _token;
  String get username => _username;

  set username(String value) {
    _username = value;
    _preferences.setString("username", value);
  }

  set token(String value) {
    _token = value;
    _preferences.setString("token", value);
  }

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString("token") ?? "";
    _username = _preferences.getString("username") ?? "";
  }

  Future<RepositoryResult<List>> login(
      {required String email,
      String deviceToken = "testing",
      String deviceInfo = "testing"}) async {
    try {
      return await BaseApi.instance.dio.post("/login", data: {
        "email": "olukoyajoshua72@gmail.com",
        "device_token": deviceToken,
        "device_info": deviceToken
      }).then((value) {
        username = value.data["data"]["username"];
        token = value.data["data"]["token"];

        return RepositoryResult(
            message: value.data["message"] ?? "Authentication successful",
            status: true,
            result: []);
      });
    } on DioException catch (e) {
      print(e.response);
      return RepositoryResult(
          message: e.response?.data["message"] ?? "failed to process request",
          status: false,
          result: []);
    } catch (e) {
      return const RepositoryResult(
          message: "Failed to process request", status: false, result: []);
    }
  }
}
