import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/either_extension.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/features/profile_details/data/repo/profile_repo.dart';
import 'package:homez/features/register/controller.dart';
import 'package:homez/features/search/default_search_view.dart';
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

  Future<void> profileInfoData() async {
    try {
      Either<Failure, ProfileDataModel> response =
          await profileRepo.profileInfoData();
      if (response.isRight()) {
        final righavlue = response.asRight();
        controllers.phoneController.text = righavlue.data!.user!.phone!;
      }
    } catch (e) {
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

  Future<void> updatePhone({
    required String phone,
  }) async {
    if (formKey.currentState!.validate()) {
      emit(UpdatePhoneLoadingState());
      try {
        final response = await profileRepo.updatePhone(phone: phone);
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
        if (l is ServerFailure) {
          log('Server Failure:${l.errMessage}');
        } else {
          log('An unknown error: $l');
        }
        emit(UpdateProfileFailedState(msg: l.toString()));
      }, (r) => emit(UpdateProfileSuccessState()));
    } catch (e) {
      emit(UpdateProfileFailedState(msg: e.toString()));
    }
  }
  Future<void> deleteSocialAccount() async {
    emit(DeleteAccountLoadingState());
    try {
      final response = await profileRepo.deleteSocialAccount();
      response.fold((l) => emit(DeleteAccountFailedState(l.toString())), (r) {
        CacheHelper.removeToken();
        emit(DeleteAccountSuccessState(r));
      });
    } catch (e) {
      emit(DeleteAccountFailedState(e.toString()));
    }
  }
  Future<void> deleteAccount({required String password}) async {
    emit(DeleteAccountLoadingState());
    try {
      final response = await profileRepo.deleteAccount(password: password);
      response.fold((l) => emit(DeleteAccountFailedState(l.toString())), (r) {
        CacheHelper.removeToken();
        emit(DeleteAccountSuccessState(r));
      });
    } catch (e) {
      emit(DeleteAccountFailedState(e.toString()));
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
