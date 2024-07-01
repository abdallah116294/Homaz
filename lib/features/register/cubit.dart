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

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  final dioManager = DioManager();
  final formKey = GlobalKey<FormState>();
  final controllers = RegisterControllers();
  final logger = Logger();
  bool isObscure = true;
  bool isConObscure = true;

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());
      try {
        final response = await dioManager.post(
          ApiConstants.register,
          data: FormData.fromMap({
            "username": controllers.nameController.text,
            "phone": controllers.phoneController.text,
            "password": controllers.passwordController.text,
          }),
        );

        Map<String, dynamic> json = jsonDecode(response.data);
        if (response.statusCode == 200) {
          emit(RegisterSuccessState());
          CacheHelper.saveIfRemember();
          CacheHelper.saveToken("${json["user_id"]}");
          logger.i("id: ${json["user_id"]}");
        } else {
          emit(RegisterFailedState(msg: json["status"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(RegisterFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(RegisterFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(RegisterNetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        Map<String, dynamic> json = jsonDecode(e.response?.data);
        emit(RegisterFailedState(msg: json["status"]));
        break;
      default:
        emit(RegisterNetworkErrorState());
    }
    logger.e(e);
  }

  changeVisibility() {
    isObscure = !isObscure;
    emit(ChanceVisibilityState());
  }

  conChangeVisibility() {
    isConObscure = !isConObscure;
    emit(ConChangeVisibilityState());
  }

  //================================================================

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
