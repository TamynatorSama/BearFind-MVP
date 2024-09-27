import 'package:dio/dio.dart';

class BaseApi {
  Dio? _dio;

  Dio get dio {
    if (_dio == null) {
      _dio = Dio();
      _dio!.options.baseUrl = "https://fndrly.4runnerglobal.org/api/v1";
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
