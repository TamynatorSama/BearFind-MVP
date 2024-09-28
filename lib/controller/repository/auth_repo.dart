import 'package:dio/dio.dart';
import 'package:lost_items/model/repository_result.dart';
import 'package:lost_items/utils/base_dio.dart';
import 'package:lost_items/utils/push_noti_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  String _username = "";
  String _token = "";
  double? _walletAmount = 0;
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
  double? get walletAmount => _walletAmount;
  set username(String value) {
    _username = value;
    _preferences.setString("username", value);
  }

  set token(String value) {
    _token = value;
    _preferences.setString("token", value);
  }

  set walletAmount(double? value) {
    _walletAmount = value;
    _preferences.setString("wallet", value.toString());
  }

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
    _token = _preferences.getString("token") ?? "";
    _username = _preferences.getString("username") ?? "";
    walletAmount = double.tryParse(_preferences.getString("wallet") ?? "");
  }

  Future<RepositoryResult<List>> login(
      {required String email,}) async {
    try {
      return await BaseApi.instance.dio.post("/login", data: {
        "email": email,
        "device_token": await PushNotificationHandler.generateDeviceToken(),
        "device_info": await deviceInfo()
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
