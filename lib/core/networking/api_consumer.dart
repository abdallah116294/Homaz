import 'package:dio/dio.dart';

abstract class ApiConsumer {
  Future<dynamic> get(String path,
      {Map<String, dynamic>? queryParameters, String? token,Map<String, dynamic>? header});
  Future<dynamic> post(String path,
      {Map<String, dynamic>? queryParameters,
      String? token,
      FormData? body,Map<String, dynamic>? header});
  Future<dynamic> delete(String url,
      {Map<String, dynamic>? header, dynamic data});
  Future<dynamic> put(String url,
      {Map<String, dynamic>? header, Map<String,dynamic>? data});
}
