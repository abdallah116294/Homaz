import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:homez/features/profile_details/data/repo/profile_repo.dart';
import 'package:homez/features/register/controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

part 'profile_details_state.dart';

class ProfileDetailsCubit extends Cubit<ProfileDetailsState> {
  ProfileDetailsCubit({required this.profileRepo})
      : super(ProfileDetailsInitial());
  ProfileDetailsRepo profileRepo;
  // final dioManager = DioManager();
  final formKey = GlobalKey<FormState>();
  final controllers = RegisterControllers();
  final logger = Logger();
  bool isObscure = true;
  bool isConObscure = true;
  XFile? pickedImage;
  pickImage(ImageSource source) async {
    emit(PickImageLoadingState());
    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source);
      if (image == null) return;

      pickedImage = image;

      print(pickedImage);

      emit(PickImageSuccessState());
    } catch (e) {
      print("failed to pick image : $e");
      emit(PickImageFailedState(e.toString()));
    }
  }
Future<void>profileInfoData()async{
  try{
    final response = await profileRepo.profileInfoData();
  }catch(e){
    logger.e(e);
  }
}
  changeVisibility() {
    isObscure = !isObscure;
    emit(ChanceVisibilityState());
  }

  Future<void> updateProfile() async {
    if (formKey.currentState!.validate()) {
      emit(UpdateProfileLoadingState());
      try {
        final response = await profileRepo.updateProfile(
            fullName: controllers.nameController.text);
        response.fold((l) => emit(UpdateProfileFailedState(msg: l.toString())),
            (r) => emit(UpdateProfileSuccessState()));
      } catch (e) {
        emit(UpdateProfileFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  Future<void> updatePhone() async {
    if (formKey.currentState!.validate()) {
      emit(UpdatePhoneLoadingState());
      try {
        final response = await profileRepo.updatePhone(
            phone: controllers.phoneController.text);
        response.fold((l) => emit(UpdatePhoneFailedState(msg: l.toString())),
            (r) => emit(UpdatePhoneSuccessState()));
      } catch (e) {
        emit(UpdatePhoneFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  Future<void> updateProfile2({
    String? fullName,
    XFile? image,
  }) async {
    emit(UpdateProfileLoadingState());
    try {
      final response =
          await profileRepo.updateProfile2(fullName: fullName, image: image);
      response.fold((l) {
        if(l is ServerFailure){
          log('Server Failure:${l.errMessage}');
        }else{
          log('An unknown error: $l');
        }
        emit(UpdateProfileFailedState(msg: l.toString()));
      }, (r) => emit(UpdateProfileSuccessState()));
    } catch (e) {
      emit(UpdateProfileFailedState(msg: e.toString()));
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(UpdateProfileFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(UpdateProfileFailedState(msg: e.response?.data["message"]));
        break;
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
