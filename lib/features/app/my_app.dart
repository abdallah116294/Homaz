import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/app_config.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/localization/app_localization_setup.dart';
import 'package:homez/core/networking/dio_manager.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
import 'package:homez/features/splash/view.dart';
import 'package:homez/injection_container.dart'as di;
import '../../core/helpers/navigator.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _requestPermission();
    _getDeviceToken();
    checkPlatform();
  }

  void _requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void _getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    CacheHelper.put(key: 'deviceToken', value: token);
    print("Device Token: $token");
  }

  void checkPlatform() {
    if (Platform.isAndroid) {
      CacheHelper.put(key: 'deviceType', value: 'android');
    } else if (Platform.isIOS) {
      CacheHelper.put(key: 'deviceType', value: 'ios');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
         final config = AppConfig.of(context);
        return BlocProvider(
          create: (context) =>AppCubit(),
          child: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
            if (state is SelectedLocale) {
              log(state.locale.languageCode);
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
                child: MaterialApp(
                  locale: state.locale,
                  supportedLocales: AppLocalizationsSetup.supportedLocales,
                  localizationsDelegates:
                      AppLocalizationsSetup.localizationsDelegates,
                  localeResolutionCallback:
                      AppLocalizationsSetup.localeResolutionCallback,
                  title: "Home Z",
                  debugShowCheckedModeBanner:config!.appTitle=="Homze Development "? true:false,
                  navigatorKey: navigatorKey,
                  home: child,
                ),
              );
            }
            return Container();
          }),
        );
      },
      child: const SplashView(),
    );
  }
}
