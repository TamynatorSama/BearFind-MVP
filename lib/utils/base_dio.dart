import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lost_items/main.dart';
import 'package:lost_items/pages/auth/email_page.dart';
import 'package:lost_items/utils/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseApi {
  Dio? _dio;

  Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = "https://fndrly.4runnerglobal.org/api/v1";
      _dio!.interceptors.add(UnAuthorizedInterceptor());
      _dio!.options.headers = {
        "Content-Type": "application/json",
        "app_id": "7d1b5fb2-0979-465a-82ef-2194da68600d"
      };
    }
    return _dio!;
  }

  BaseApi._privateConstructor();

  // Static final instance
  static final BaseApi _instance = BaseApi._privateConstructor();

  // Static method
  static BaseApi get instance {
    return _instance;
  }
}

class UnAuthorizedInterceptor extends Interceptor {
  
  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && err.response?.data.toString().toLowerCase() == "unauthorized") {
      // Shared
      await Navigator.pushAndRemoveUntil(
          MyAppState.navKey.currentContext!,
          MaterialPageRoute(builder: (context) => const EmailWidget()),
          (setting) => false);
          ScaffoldMessenger.of(MyAppState.navKey.currentContext!).showSnackBar(SnackBar(
              backgroundColor: AppTheme.primaryColor,
              content: Text(
                "Auth timeout",
                style: AppTheme.buttonTextStyle.copyWith(fontSize: 12),
              )));
      final instance = await SharedPreferences.getInstance();
      instance.clear();
    }
    handler.next(err);
  }
}
