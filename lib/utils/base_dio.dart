import 'package:dio/dio.dart';

class BaseApi {
  Dio? _dio;

  Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = "https://fndrly.4runnerglobal.org/";
      _dio!.options.headers = {
        "Content-Type": "application/json"
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
