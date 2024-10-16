import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/config/routes/base_routes.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/features/about_us/screen/about_us_screen.dart';
import 'package:homez/features/appartment_details/screen/appartment_details.dart';
import 'package:homez/features/change_password/view.dart';
import 'package:homez/features/chat/chat_screen.dart';
import 'package:homez/features/chat/cubit/chat_cubit.dart';
import 'package:homez/features/forget_password/forget_pass_view.dart';
import 'package:homez/features/landing_screen/landing_screen_views.dart';
import 'package:homez/features/legel/screens/legel_and_poilices.dart';
import 'package:homez/features/login/view.dart';
import 'package:homez/features/notification/notification_view.dart';
import 'package:homez/features/on_boarding/view.dart';
import 'package:homez/features/otp/view.dart';
import 'package:homez/features/profile_details/enter_password_to_delete_account_view.dart';
import 'package:homez/features/profile_details/profile_details.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';
import 'package:homez/features/register/view.dart';
import 'package:homez/features/reset_password/view.dart';
import 'package:homez/features/search/data/models/search_result_model.dart';
import 'package:homez/features/search/search_filter_view.dart';
import 'package:homez/features/search/search_result_screen.dart';
import 'package:homez/features/search/search_screen.dart';
import 'package:homez/features/splash/view.dart';
import 'package:homez/features/take_look/data/model/take_look_model.dart';

import '../../features/take_look/take_look_screen.dart';
import 'package:homez/injection_container.dart' as di;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static const String splashView = "SplashView";
  static const String onBoardingView = "OnBoardingView";
  static const String loginView = "LoginView";
  static const String landingViews = "LandingScreenViews";
  static const String apartmentDetailsView = "ApartmentDetailsScreen";
  static const String searchScreenView = "SearchScreenViews";
  static const String otpView = "OtpView";
  static const String profileDetailsView = "ProfileDetailsView";
  static const String changePasswordView = "ChangePasswordView";
  static const String registerView = "RegisterView";
  static const String forgetPasswordView = "ForgetPasswordViews";
  static const String takeALookView = "TakeLookScreen";
  static const String notificationView = "NotificationView";
  static const String chatScreen = "ChatScreen";
  static const String legalAndPoliciesScreen = "LegalAndPoliciesScreen";
  static const String aboutHomzPage = "AboutHomzPage";
  static const String searchFilter = "SearchFilterView";
  static const String searchresultScreen = "SearchResultScreen";
  static const String enterPasswordToDeleteAccountView =
      "EnterPasswordToDeleteAccountView";
  static const String resetPasswordView = "ResetPasswordView";

  static BuildContext currentContext = navigatorKey.currentContext!;
  static Route? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splashView:
        return BaseRoute(page: const SplashView());
      case onBoardingView:
        return BaseRoute(page: const OnBoardingView());
      case loginView:
        return BaseRoute(page: const LoginView());
      case landingViews:
        return BaseRoute(page: const LandingScreenViews());
      case apartmentDetailsView:
        final arg2 = args as Map<String, dynamic>;

        return BaseRoute(
            page: ApartmentDetailsScreen(
          apartmentId: arg2['apartmentId'] as int,
          takeLookData: arg2['takeLookData'] as TakeLookData?,
        ));
      case searchScreenView:
        return BaseRoute(
            page: SearchScreenViews(
          searchString: args as String?,
        ));
      case otpView:
        final otpArg = args as Map<String, dynamic>;
        return BaseRoute(
            page: OtpView(
          email: otpArg['email'] as String,
          phone: otpArg['phone'] as String,
          navigateFromForget: otpArg['navigateFromForget'] as bool,
          navigateFromProfile: otpArg['navigateFromProfile'] as bool,
        ));
      case profileDetailsView:
        final profileDatailsArgs = args as Map<String, dynamic>;
        return BaseRoute(
            page: ProfileDetailsView(
          fullName: profileDatailsArgs['fullName'] as String,
          phone: profileDatailsArgs['phone'] as String,
          userData: profileDatailsArgs['userData'] as User,
          navigateFromProfile:
              profileDatailsArgs["navigateFromProfile"] as bool,
        ));
      case changePasswordView:
        return BaseRoute(page: const ChangePasswordView());
      case registerView:
        return BaseRoute(page: const RegisterView());
      case forgetPasswordView:
        final fogetPasswordArgs = args as Map<String, dynamic>?;
        return BaseRoute(
            page: ForgetPasswordViews(
          phone: fogetPasswordArgs?['phone'] as String?,
        ));
      case takeALookView:
        return BaseRoute(page: TakeLookScreen(id: args as int));
      case notificationView:
        return BaseRoute(page: const NotificationView());
      case chatScreen:
        final chatArgs = args as Map<String, dynamic>;
        return BaseRoute(
            page: BlocProvider(
          create: (context) => di.sl<ChatCubit>()
            ..displayChat(chatId: chatArgs['roomId'] as int),
          child: ChatScreen(
            chatName: chatArgs['chatName'] as String,
            imageUrl: chatArgs['imageUrl'] as String,
            roomId: chatArgs['roomId'] as int,
          ),
        ));
      case legalAndPoliciesScreen:
        return BaseRoute(page: const LegalAndPoliciesScreen());
      case aboutHomzPage:
        return BaseRoute(page: const AboutHomzPage());
      case searchFilter:
        final searchFilterArgs = args as Map<String, dynamic>;
        return BaseRoute(
            page: SearchFilterView(
          searchController:
              searchFilterArgs['searchController'] as TextEditingController,
        ));
      case searchresultScreen:
        final searchScreenArgs = args as Map<String, dynamic>;
        return BaseRoute(
            page: SearchResultScreen(
          apartment: searchScreenArgs['apartment']! as Apartment,
        ));
      case enterPasswordToDeleteAccountView:
        return BaseRoute(
            page: BlocProvider(
          create: (context) => di.sl<ProfileDetailsCubit>(),
          child: EnterPasswordToDeleteAccountView(),
        ));
      case resetPasswordView:
        final resetpassewordArg = args as Map<String, dynamic>;
        return BaseRoute(
            page: ResetPasswordView(
          phone: resetpassewordArg['phone'] as String,
          otp: resetpassewordArg['otp'] as String,
        ));
      default:
        return null;
    }
  }
}
