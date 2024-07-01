import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:logger/logger.dart';

import 'states.dart';

class SendEmailCubit extends Cubit<SendEmailStates> {
  SendEmailCubit() : super(SendEmailInitialState());

  final dioManager = DioManager();
  final logger = Logger();
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool ifFilledEmail = false;

  Future<void> sendEmail() async {
    if (formKey.currentState!.validate() && ifFilledEmail) {
      emit(SendEmailLoadingState());
      try {
        final response = await dioManager.post(
          " UrlsStrings.forgetPasswordUrl",
          data: FormData.fromMap({
            "email": emailController.text,
          }),
        );
        if (response.statusCode == 200) {
          emit(SendEmailSuccessState());
        } else {
          Map<String, dynamic> json = jsonDecode(response.data);
          emit(SendEmailFailureState(msg: json["status"]));
        }
      } on DioException catch (e) {
        handleDioException(e);
      } catch (e) {
        emit(SendEmailFailureState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(SendEmailFailureState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(SendEmailNetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        Map<String, dynamic> json = jsonDecode(e.response?.data);
        emit(SendEmailFailureState(msg: json["status"]));
        break;
      default:
        emit(SendEmailNetworkErrorState());
    }
    logger.e(e);
  }

  fillEmail() {
    ifFilledEmail = emailController.text.isNotEmpty;
    emit(FillEmailState());
  }

  @override
  Future<void> close() {
    emailController.dispose();
    return super.close();
  }
}
