import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/change_password/data/repo/change_pass_repo.dart';
import 'package:logger/logger.dart';

import 'controller.dart';
import 'states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit({required this.changePassRepo})
      : super(ChangePasswordInitialState());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);
  ChangePassRepo changePassRepo;
  final formKey = GlobalKey<FormState>();
  final controllers = ChangePasswordControllers();
  bool isCurrentObscure = true;
  bool isObscure = true;
  bool isConObscure = true;
  //final dioManager = DioManager();
  final logger = Logger();

  changeCurrentVisibility() {
    isCurrentObscure = !isCurrentObscure;
    emit(ChangeCurrentVisibilityState());
  }

  changeVisibility() {
    isObscure = !isObscure;
    emit(ChangeVisibilityState());
  }

  conChangeVisibility() {
    isConObscure = !isConObscure;
    emit(ConChangeVisibilityState());
  }

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      emit(ChangePasswordLoadingState());
      try {
        final response = await changePassRepo.changePassword(
          oldPassword: controllers.currentPasswordController.text,
          confirmPassword: controllers.confirmPasswordController.text,
          password: controllers.newPasswordController.text,
        );
        response.fold((l)=>emit(ChangePasswordFailedState(msg: l.toString())), (r)=>emit(ChangePasswordSuccessState()));
      } catch (e) {
        emit(ChangePasswordFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }



  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
