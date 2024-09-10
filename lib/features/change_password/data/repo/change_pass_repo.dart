import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';

class ChangePassRepo {
  final ApiConsumer apiConsumer;
  ChangePassRepo({required this.apiConsumer});
  Future<Either<Failure, dynamic>> changePassword({
    required String oldPassword,
    required String confirmPassword,
    required String password,
  }) async {
    try {
      final response = await apiConsumer.post(ApiConstants.editPassword,
      header: {
        "Accept": "application/json",
      },
          body: FormData.fromMap({
            "old_password": oldPassword,
            "password": password,
            "confirm_password": confirmPassword,
          }));
      if (response.statusCode == 200) {
        return Right(response.data);
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
}
