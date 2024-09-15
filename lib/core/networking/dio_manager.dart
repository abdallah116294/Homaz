import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:homez/core/error/error.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/core/networking/status_code.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:homez/injection_container.dart' as di;

import 'api_constants.dart';

class DioManager implements ApiConsumer {
  Dio dio;
  DioManager({required this.dio}) {
    dio.options
      ..baseUrl = ApiConstants.apiBaseUrl
      ..connectTimeout = const Duration(seconds: 40)
      ..receiveTimeout = const Duration(seconds: 40)
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
    //!Use Injection
    dio.interceptors.add(di.sl<PrettyDioLogger>());
    String token = CacheHelper.getToken() ?? "";
    String langcode = CacheHelper.get(key: "selected_language")??"en";
    token.isNotEmpty
        ? dio.options.headers["Authorization"] = "Bearer $token"
        : null;
     dio.options.headers["Accept-Language"] = langcode;   
    print(token);
  }
  @override
  Future delete(String url, {Map<String, dynamic>? header, data}) async {
    try {
      final response =
          await dio.delete(url, data: data, options: Options(headers: header));
      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future get(String path,
      {Map<String, dynamic>? queryParameters,
      String? token,
      Map<String, dynamic>? header}) async {
    try {
      final response = await dio.get(path,
          options: Options(headers: header), queryParameters: queryParameters);
      return response;
      //  return _handleResponseAsJson(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future post(String path,
      {Map<String, dynamic>? queryParameters,
      String? token,
      FormData? body,
      Map<String, dynamic>? header}) async {
    try {
      final response = await dio.post(path,
          data: body,
          options: Options(headers: header),
          queryParameters: queryParameters);
      return response;
      // return _handleResponseAsJson(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future put(String url,
      {Map<String, dynamic>? header, Map<String, dynamic>? data}) async {
    try {
      final response =
          await dio.put(url, data: data, options: Options(headers: header));
      return _handleResponseAsJson(response);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  //Handel Response As JSON
  dynamic _handleResponseAsJson(Response<dynamic> response) {
    final responseJson = json.decode(response.data.toString());
    return responseJson;
  }

  //Handel Error
  dynamic _handleDioError(DioException error) {
    if (error.type
        case DioExceptionType.connectionTimeout ||
            DioExceptionType.sendTimeout ||
            DioException.receiveTimeout) {
      throw const FetchDataException();
    } else if (error.type case DioExceptionType.values) {
      switch (error.response?.statusCode) {
        case StatusCode.badRequest:
          throw const BadRequestException();
        case StatusCode.unauthorized:
        case StatusCode.forbidden:
          throw const UnauthorizedException();
        case StatusCode.notFound:
          throw const NotFoundException();
        case StatusCode.confilct:
          throw const ConflictException();

        case StatusCode.internalServerError:
          throw const InternalServerErrorException();
      }
    } else if (error.type case DioExceptionType.cancel) {
    } else if (error.type case DioExceptionType.unknown) {
      throw const NoInternetConnectionException();
    } else if (error.type
        case DioExceptionType.receiveTimeout ||
            DioExceptionType.badCertificate) {}
  }
}
