import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'controller.dart';
import 'states.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit() : super(ChangePasswordInitialState());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();
  final controllers = ChangePasswordControllers();
  bool isCurrentObscure = true;
  bool isObscure = true;
  bool isConObscure = true;

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

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
