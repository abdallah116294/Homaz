import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/features/appartment_details/data/repo/apartment_repo.dart';
import 'package:homez/features/change_password/cubit.dart';
import 'package:homez/features/change_password/data/repo/change_pass_repo.dart';
import 'package:homez/features/forget_password/data/repo/forget_pass_repo.dart';
import 'package:homez/features/forget_password/forget_password_cubit.dart';
import 'package:homez/features/home/data/repo/home_repo.dart';
import 'package:homez/features/home/home_cubit.dart';
import 'package:homez/features/login/cubit.dart';
import 'package:homez/features/login/data/repo/login_repo.dart';
import 'package:homez/features/otp/cubit.dart';
import 'package:homez/features/otp/data/repo/otp_repo.dart';
import 'package:homez/features/profile/data/repo/profile_repo.dart';
import 'package:homez/features/profile/profile_cubit.dart';
import 'package:homez/features/profile_details/data/repo/profile_repo.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';
import 'package:homez/features/register/cubit.dart';
import 'package:homez/features/register/data/repo/register_repo.dart';
import 'package:homez/features/reset_password/cubit.dart';
import 'package:homez/features/reset_password/data/repo/reset_password_repo.dart';
import 'package:homez/features/saved/cubit/favorite_cubit.dart';
import 'package:homez/features/saved/data/repo/favorite_repo.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/data/repo/search_repo.dart';
import 'package:homez/features/take_look/cubit/take_look_cubit.dart';
import 'package:homez/features/take_look/data/repo/take_look_repo.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final sl = GetIt.instance;
Future<void> init() async {
  //!Register
  //repo
  sl.registerLazySingleton<RegisterRepo>(() => RegisterRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(registerRepo: sl()));
//!Login
  //repo
  sl.registerLazySingleton<LoginRepo>(() => LoginRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<LoginCubit>(() => LoginCubit(loginRepo: sl()));
  //!Reset Password
  //repo
  sl.registerLazySingleton<ResetPasswordRepo>(
      () => ResetPasswordRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<ResetPasswordCubit>(
      () => ResetPasswordCubit(resetPasswordRepo: sl()));
  //!OTP
  //cubit
  sl.registerFactory(() => OtpCubit(otpRepo: sl()));
  //repo
  sl.registerLazySingleton<OTPRepo>(() => OTPRepo(apiConsumer: sl()));

  //!Change Password
  //repo
  sl.registerLazySingleton<ChangePassRepo>(
      () => ChangePassRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<ChangePasswordCubit>(
      () => ChangePasswordCubit(changePassRepo: sl()));
//!Forget Passsword
  //repo
  sl.registerLazySingleton<ForgetPassRepo>(
      () => ForgetPassRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<ForgetPasswordCubit>(
      () => ForgetPasswordCubit(forgetPassRepo: sl()));
  //!Home
  //repo
  sl.registerLazySingleton<HomeRepo>(() => HomeRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<HomeCubit>(() => HomeCubit(homeRepo: sl()));
  //!ProFile Details
  //repo
  sl.registerLazySingleton<ProfileDetailsRepo>(
      () => ProfileDetailsRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory<ProfileDetailsCubit>(
      () => ProfileDetailsCubit(profileRepo: sl()));
  //!Profile
  //repo
  sl.registerLazySingleton<ProfileRepo>(() => ProfileRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory(() => ProfileCubit(profileRepo: sl()));
  //!Take Look
  //repo
  sl.registerLazySingleton<TakeLookRepo>(() => TakeLookRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory(() => TakeLookCubit(takeLookRepo: sl()));
  //!Apartment Details
  //repo
  sl.registerLazySingleton<ApartmentRepo>(
      () => ApartmentRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory(
      () => AppartmentDetailsCubit(apartmentRepo: sl(), favoriteRepo: sl()));
  //!Favorite
  //repo
  sl.registerLazySingleton<FavoriteRepo>(() => FavoriteRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory(() => FavoriteCubit(favoriteRepo: sl()));
  //!Search
  //repo
  sl.registerLazySingleton<SearchRepo>(() => SearchRepo(apiConsumer: sl()));
  //cubit
  sl.registerFactory(() => SearchCubit(searchRepo: sl()));
  //core
  sl.registerLazySingleton<ApiConsumer>(() => DioManager(dio: sl()));
  sl.registerLazySingleton<DioManager>(() => DioManager(dio: sl()));
  sl.registerLazySingleton(() => PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        request: true,
        responseBody: true,
        responseHeader: true,
        compact: true,
        maxWidth: 120,
      ));
  sl.registerFactory(() => Dio());
}
