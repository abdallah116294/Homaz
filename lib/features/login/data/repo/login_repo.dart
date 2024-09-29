import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/login/data/model/login_model_success.dart';

class LoginRepo {
  final ApiConsumer apiConsumer;
  LoginRepo({required this.apiConsumer});
  Future<Either<Failure, LoginUserSuccess>> loginUser({
    required String phone,
    required String password,
    required String deviceToken,
    required String deviceType,
  }) async {
    try {
      final response = await apiConsumer.post(ApiConstants.login,
          body: FormData.fromMap({
            "password": password,
            'device_token': deviceToken,
            'type': deviceType,
            "phone": phone,
          }));
      if (response.statusCode == 200) {
        return Right(LoginUserSuccess.fromJson(response.data));
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

  Future<Either<Failure, LoginUserSuccess>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        // return;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final result =
          await FirebaseAuth.instance.signInWithCredential(credential);
      // Send these tokens to your backend for verification and session management
      final response = await apiConsumer.post(
        ApiConstants.loginSocial,
        body: FormData.fromMap({
          'provider': 'google',
          'provider_id': result.user!.uid,
          'type': '${CacheHelper.get(key: 'deviceType')}',
          'device_token': '${CacheHelper.get(key: 'deviceToken')}',
        }),
      );
      if (response.statusCode == 200) {
        log('Handle successful sign-in');
        // Handle successful sign-in
        log("Login With Google Response:" + response.data.toString());
        return Right(LoginUserSuccess.fromJson(response.data));
      } else {
        log('Handle sign-in failure');
        return Left(ServerFailure(response.data));
        // Handle sign-in failure
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(ServerFailure(e.toString())) ;
      } else {
        return Left(ServerFailure('An unknown error: $e'));
      }
    }
  }
}
