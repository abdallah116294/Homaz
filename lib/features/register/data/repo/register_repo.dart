import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/register/data/model/register_model.dart';

class RegisterRepo {
  final ApiConsumer apiConsumer;
  RegisterRepo({required this.apiConsumer});
  Future<Either<Failure, RegisterUserSuccess>> registerUser({
    required String name,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiConsumer.post(ApiConstants.register,
          body: FormData.fromMap({
            "fullname": name,
            "password": password,
            "confirm_password": confirmPassword,
            "phone": phone,
            "terms": '1',
          }),header: {
            "Accept": 'application/json',
          });
      if (response.statusCode == 200) {
        return Right(RegisterUserSuccess.fromJson(response.data));
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
