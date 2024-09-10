import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';

class ProfileDetailsRepo {
  final ApiConsumer apiConsumer;
  ProfileDetailsRepo({required this.apiConsumer});
  Future<Either<Failure, dynamic>> updateProfile(
      {required String fullName}) async {
    try {
      final respnse = await apiConsumer.post(
        ApiConstants.updateProfile,
        body: FormData.fromMap({'fullname': fullName}),
        header: {
          "Accept": "application/json",
        },
      );
      if (respnse.statusCode == 200) {
        return Right(respnse.data);
      } else {
        return Left(ServerFailure(respnse.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, dynamic>> updatePhone({required String phone}) async {
    try {
      final respnse = await apiConsumer.post(
        ApiConstants.updateProfile,
        body: FormData.fromMap({'phone': phone}),
        header: {
          "Accept": "application/json",
        },
      );
      if (respnse.statusCode == 200) {
        return Right(respnse.data);
      } else {
        return Left(ServerFailure(respnse.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }
}
