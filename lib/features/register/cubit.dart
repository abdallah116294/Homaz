
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/features/register/data/repo/register_repo.dart';
import 'package:logger/logger.dart';

import 'controller.dart';
import 'states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit({required this.registerRepo}) : super(RegisterInitialState());
  RegisterRepo registerRepo;
  static RegisterCubit get(context) => BlocProvider.of(context);

  //final dioManager = DioManager();
  final formKey = GlobalKey<FormState>();
  final controllers = RegisterControllers();
  final logger = Logger();
  bool isObscure = true;
  bool isConObscure = true;

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());
      try {
        final response = await registerRepo.registerUser(
          name: controllers.nameController.text,
          phone: controllers.phoneController.text,
          password: controllers.passwordController.text,
          confirmPassword: controllers.confirmPasswordController.text,
        );
        response.fold((l) => emit(RegisterFailedState(msg: l.toString())),
            (r) => emit(RegisterSuccessState()));
      } catch (e) {
        emit(RegisterFailedState(msg: 'An unknown error: $e'));
        logger.e(e);
      }
    }
  }

  Future<void> registerWithGoogle() async {
    emit(RegisterWithGoogleLoadingState());
    try {
      final rseponse = await registerRepo.registerWithGoogle();
      rseponse.fold(
          (l) => emit(RegisterWithGoogleFailedState(msg: l.toString())), (r) {
          //   CacheHelper.saveToken(r.data!.user!.!);
        emit(RegisterWithGoogleSuccessState(registerUserSuccess: r));
      });
      // emit(RegisterWithGoogleSuccessState(registerUserSuccess: ));
    } catch (e) {
      emit(RegisterWithGoogleFailedState(msg: e.toString()));
    }
  }
  
  // Future<void> registerWithGoogle() async {
  //   emit(RegisterWithGoogleLoadingState());
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  //     if (googleUser == null) {
  //       // The user canceled the sign-in
  //       return;
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;

  //     AuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final result =
  //         await FirebaseAuth.instance.signInWithCredential(credential);
  //     // Send these tokens to your backend for verification and session management
  //     final response = await dioManager.post(
  //       ApiConstants.register,
  //       data: FormData.fromMap({
  //         'fullname': result.user!.displayName,
  //         'password': 'hamdy_167',
  //         'confirm_password': 'hamdy_167',
  //         'phone': '01018482081189',
  //         'terms': '1',
  //         'provider': 'google',
  //         'provider_id': result.user!.uid,
  //       }),
  //     );
  //     if (response.statusCode == 200) {
  //       emit(RegisterWithGoogleSuccessState());
  //       print('Successfully signed in with Google');
  //       // Handle successful sign-in
  //     } else {
  //       emit(RegisterWithGoogleFailedState(msg: response.data["message"]));

  //       print('Failed to sign in with Google');
  //       // Handle sign-in failure
  //     }
  //   } on DioException catch (e) {
  //     handleDioException(e);
  //   } catch (e) {
  //     emit(RegisterWithGoogleFailedState(msg: 'An unknown error: $e'));
  //     logger.e(e);
  //   }
  // }

  // Future<void> registerWithApple() async {
  //   emit(RegisterWithAppleLoadingState());
  //   try {
  //     final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //     );

  //     final String idToken = appleCredential.identityToken!;
  //     final String authorizationCode = appleCredential.authorizationCode;

  //     // Send these tokens to your backend for verification and session management
  //     final response = await dioManager.post(
  //       ApiConstants.register,
  //       data: FormData.fromMap({
  //         'fullname': appleCredential.familyName,
  //         'password': 'hamdy_167',
  //         'confirm_password': 'hamdy_167',
  //         // 'phone':  appleCredential.email,
  //         'provider': 'apple',
  //         'provider_id': idToken,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       emit(RegisterWithAppleSuccessState());

  //       print('Successfully signed in with Apple');
  //       // Handle successful sign-in
  //     } else {
  //       emit(RegisterWithAppleFailedState(msg: response.data["message"]));

  //       print('Failed to sign in with Apple');
  //       // Handle sign-in failure
  //     }
  //   } on DioException catch (e) {
  //     handleDioException(e);
  //   } catch (e) {
  //     emit(RegisterWithAppleFailedState(msg: 'An unknown error: $e'));
  //     logger.e(e);
  //   }
  // }

  void handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.cancel:
        emit(RegisterFailedState(msg: "Request was cancelled"));
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        emit(RegisterNetworkErrorState());
        break;
      case DioExceptionType.badResponse:
        emit(RegisterFailedState(msg: "${e.response?.data['message']}"));
        break;
      default:
        emit(RegisterNetworkErrorState());
    }
    logger.e(e);
  }

  changeVisibility() {
    isObscure = !isObscure;
    emit(ChanceVisibilityState());
  }

  conChangeVisibility() {
    isConObscure = !isConObscure;
    emit(ConChangeVisibilityState());
  }

  //================================================================

  @override
  Future<void> close() {
    controllers.dispose();
    return super.close();
  }
}
