import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:logger/logger.dart';

import 'controller.dart';
import 'states.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  final formKey = GlobalKey<FormState>();
  final dioManager = DioManager();
  final logger = Logger();
  final controllers = LoginControllers();
  bool isObscure = true;
  bool isRemember = true;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());
      try {
        final response = await dioManager.post(
          ApiConstants.login,
          data: FormData.fromMap({
            "email": controllers.phoneController.text,
            "password": controllers.passwordController.text,
          }),
        );
        Map<String, dynamic> json = jsonDecode(response.data);
        if (response.statusCode == 200) {
          emit(LoginSuccessState());
          CacheHelper.saveToken("${json["data"]['id']}");
          // CacheHelper.saveName("${json["data"]['name']}");
          // CacheHelper.saveEmail("${json["data"]['email']}");
          // CacheHelper.saveRole("${json["data"]['role']}");
          isRemember ? CacheHelper.saveIfRemember() : null;
          logger.i("id: ${json["data"]['id']}");
        } else {
          emit(LoginFailedState(msg: json["status"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(LoginFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(LoginFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        Map<String, dynamic> jsonStatus = jsonDecode(e.response?.data);
        emit(LoginFailedState(msg: jsonStatus["status"]));
        break;
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }

  changeVisibility() {
    isObscure = !isObscure;
    emit(ChanceVisibilityState());
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
