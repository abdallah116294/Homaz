import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:homez/app_config.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/language_cach.dart';
import 'package:homez/features/app/cubit/bloc_observer.dart';
import 'package:homez/firebase_options.dart';
import 'package:homez/features/app/my_app.dart';
import 'package:homez/main_common.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await CacheHelper.init();
  await di.init();
  Bloc.observer = AppBlocObserver();
  await Future.delayed(const Duration(seconds: 1), () {
    FlutterNativeSplash.remove();
  });

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  var configuredApp = const AppConfig(
    appTitle: "Homze",
    apiBaseUrl: "https://api.example.com",
    child: MyApp(),
  );

  mainCommon(configuredApp); 
  // runApp(const MyApp());
}
