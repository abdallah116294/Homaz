
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/forget_password/data/repo/forget_pass_repo.dart';
import 'package:homez/features/forget_password/forget_password_state.dart';
import 'package:logger/logger.dart';

import 'forget_pass_controllers.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit({required this.forgetPassRepo})
      : super(ForgetPasswordInitialState());
  ForgetPassRepo forgetPassRepo;
  //final dioManager = DioManager();
  final logger = Logger();
  final formKey = GlobalKey<FormState>();
  final controllers = ForgetPasswordControllers();

  Future<void> sendCode({required String phone}) async {
    emit(OtpLoadingState());
    try {
      final response = await forgetPassRepo.forgetPassword(phone: phone);
      response.fold(
          (l) => emit(ForgetPasswordFailureState(msg: l.toString())),
          (r) => emit(OtpSuccessState()));
    } catch (e) {
      emit(OtpFailureState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }
  @override
  Future<void> close() {
    controllers.phoneController.dispose();
    return super.close();
  }
}
