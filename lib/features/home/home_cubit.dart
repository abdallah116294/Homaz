import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/features/home/data/model/home_success_model.dart';
import 'package:homez/features/home/data/repo/home_repo.dart';
import 'models.dart';
part 'home_states.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit({required this.homeRepo}) : super(HomeInitial());
  HomeRepo homeRepo;

  // final logger = Logger();
  // final dioManager = DioManager();
  HomeSuccessModel? homeData;

  Future<void> getHomeData() async {
    emit(HomeDataLoadingState());
    try {
      final response = await homeRepo.getHomeData();
      response.fold((l) {
        if (l is ServerFailure) {
          log('Server Failure:${l.errMessage}');
        } else {
          log('An unknown error: $l');
        }
        emit(HomeDataFailedState(msg: l.toString()));
      }, (r) {
        log('Get Home Data Success');
        homeData = r;
        emit(HomeDataSuccessState(homeData: r));
      });
    } catch (e) {
      emit(HomeDataFailedState(msg: 'An unknown error: $e'));
    }
  }

  // void handleDioException(DioException e) {
  //   switch (e.type) {
  //     case DioExceptionType.cancel:
  //       emit(HomeDataFailedState(msg: "Request was cancelled"));
  //       break;
  //     case DioExceptionType.connectionTimeout:
  //     case DioExceptionType.receiveTimeout:
  //     case DioExceptionType.sendTimeout:
  //       emit(HomeNetworkErrorState());
  //       break;
  //     case DioExceptionType.badResponse:
  //       emit(HomeDataFailedState(msg: "${e.response?.data}"));
  //     default:
  //       emit(HomeNetworkErrorState());
  //   }
  //   logger.e(e);
  // }
}
