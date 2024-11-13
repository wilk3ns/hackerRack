import 'package:dio/dio.dart';

class DioClient {
  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 10),
        receiveTimeout: Duration(seconds: 10),
      ),
    );

    // Add interceptors for logging (optional)
    dio.interceptors.add(LogInterceptor(
      responseBody: true,
      requestBody: true,
    ));

    return dio;
  }
}
