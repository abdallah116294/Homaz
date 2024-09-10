import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/login/data/model/login_model_success.dart';

class ProfileRepo {
  final ApiConsumer apiConsumer;
  ProfileRepo({required this.apiConsumer});
  Future<Either<Failure, ProfileDataModel>> profileInfoData() async {
    try {
      final response = await apiConsumer.get(ApiConstants.showProfile);
      if (response.statusCode == 200) {
        return Right(ProfileDataModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, dynamic>> logOut() async {
    try {
      final response = await apiConsumer.post(
        ApiConstants.logout,
        body: FormData.fromMap(
            {'device': '${CacheHelper.get(key: 'deviceType')}'}),
        header: {
          "Accept": "application/json",
        },
      );
      if (response.statusCode == 200) {
        return Right(response.data);
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.toString()));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
