import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:homez/features/forget_password/forget_pass_controllers.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordStates> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());
  final formKey = GlobalKey<FormState>();
  final dioManager = DioManager();
  final logger = Logger();
  final controllers = ForgetPasswordControllers();
}
