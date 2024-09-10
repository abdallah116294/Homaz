import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:homez/features/reset_password/data/repo/reset_password_repo.dart';
import 'package:logger/logger.dart';

import 'controller.dart';
import 'states.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordStates> {
  ResetPasswordCubit({required this.resetPasswordRepo}) : super(ResetPasswordInitialState());
  ResetPasswordRepo resetPasswordRepo;
 // final dioManager = DioManager();
  final logger = Logger();
  final formKey = GlobalKey<FormState>();
  final controllers = ResetPasswordControllers();
  bool isObscure = true;
  bool isConObscure = true;

  Future<void> resetPassword(
      {required String phone, required String otp}) async {
    if (formKey.currentState!.validate()) {
      emit(ResetPasswordLoadingState());
      try {
        final response=await resetPasswordRepo.resetPassword(
          phone: phone,
          otp: otp,
          password: controllers.passwordController.text,
          confirmPassword: controllers.confirmPasswordController.text,
        );
        response.fold((l)=>emit(ResetPasswordFailedState(msg: l.toString())), (r)=>emit(ResetPasswordSuccessState()));
      } catch (e) {
        emit(ResetPasswordFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }
  changeVisibility() {
    isObscure = !isObscure;
    emit(ChangeVisibilityState());
  }

  conChangeVisibility() {
    isConObscure = !isConObscure;
    emit(ConChangeVisibilityState());
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
