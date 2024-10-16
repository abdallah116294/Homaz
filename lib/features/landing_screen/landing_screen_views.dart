import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_network_connectivity/flutter_network_connectivity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/features/landing_screen/landing_screen_cubit.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class LandingScreenViews extends StatelessWidget {
  const LandingScreenViews({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LandingScreenCubit(),
      child: const LandingBody(),
    );
  }
}

class LandingBody extends StatefulWidget {
  const LandingBody({super.key});

  @override
  State<LandingBody> createState() => _LandingBodyState();
}

class _LandingBodyState extends State<LandingBody> {
  final FlutterNetworkConnectivity _flutterNetworkConnectivity =
      FlutterNetworkConnectivity(
    isContinousLookUp: true,
    lookUpDuration: const Duration(seconds: 3),
  );
  bool? _isInternetAvailableOnCall;

  bool? _isInternetAvailableStreamStatus;

  StreamSubscription<bool>? _networkConnectionStream;
  @override
  void initState() {
    super.initState();

    _flutterNetworkConnectivity.getInternetAvailabilityStream().listen((event) {
      _isInternetAvailableStreamStatus = event;
      setState(() {});
    });

    init();
  }

  void init() async {
    await _flutterNetworkConnectivity.registerAvailabilityListener();
  }

  Future<void> _checkInternetAvailability() async {
    try {
      _isInternetAvailableOnCall =
          await _flutterNetworkConnectivity.isInternetConnectionAvailable();
    } on PlatformException {
      _isInternetAvailableOnCall = null;
    }

    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() async {
    _networkConnectionStream?.cancel();
    _flutterNetworkConnectivity.unregisterAvailabilityListener();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LandingScreenCubit>(context);
    return BlocBuilder<LandingScreenCubit, LandingScreenState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.bgColor,
          body: _isInternetAvailableStreamStatus == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              :_isInternetAvailableStreamStatus!? cubit.getCurrentView: Center(
                  child: Text(
                    "🌐 ${context.translate(LangKeys.network_check)} 🔄",
                    style: TextStyle(
                      fontSize: 17.0.sp,
                      color: ColorManager.white,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ),
          bottomNavigationBar: SalomonBottomBar(
              selectedColorOpacity: 1,
              // unselectedItemColor: ,
              selectedItemColor: ColorManager.blueColor,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeNavigationBottom(index);
              },
              margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              items: cubit.buildBottomNavigationItems(context)),
        );
      },
    );
  }
}
