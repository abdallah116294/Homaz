import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/features/splash/view.dart';

import 'core/helpers/navigator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: MaterialApp(
            title: "Home Z",
            debugShowCheckedModeBanner: false,
            navigatorKey: navigatorKey,
            home: child,
          ),
        );
      },
      child: const SplashView(),
    );
  }
}
