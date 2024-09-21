import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/features/profile/data/repo/profile_repo.dart';
import 'package:logger/logger.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.profileRepo}) : super(ProfileInitial());
  ProfileRepo profileRepo;
  final logger = Logger();
  // final dioManager = DioManager();
  ProfileDataModel? profileData;

  Future<void> profileInfoData() async {
    emit(ProfileDataLoadingState());
    try {
      final response = await profileRepo.profileInfoData();
      response.fold((l) {
        if (l is ServerFailure) {
          log('Server Failure:${l.errMessage}');
        } else {
          log('An unknown error: $l');
        }
        emit(ProfileDataFailedState(msg: l.toString()));
      }, (r) {
        profileData = r;
        CacheHelper.put(
          key: 'ProfileName',
          value: "${profileData!.data!.user!.fullname}",
        );
        emit(ProfileDataSuccessState());
      });
    } catch (e) {
      emit(ProfileDataFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(ProfileDataFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(ProfileDataFailedState(msg: "${e.response?.data}"));
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }

  Future<void> logOut() async {
    emit(LogOutLoadingState());
    try {
      final response = await profileRepo.logOut();
      response.fold((l) => emit(LogOutFailedState(msg: l.toString())), (r) {
        CacheHelper.removeToken();
        emit(LogOutSuccessState());
      });
    } catch (e) {
      emit(LogOutFailedState(msg: 'An unknown error: $e'));
      logger.e(e);
    }
  }

  void logoutHandleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(LogOutFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(NetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(LogOutFailedState(msg: "${e.response?.data}"));
      default:
        emit(NetworkErrorState());
    }
    logger.e(e);
  }
}
