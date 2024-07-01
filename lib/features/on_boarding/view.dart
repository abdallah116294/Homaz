import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/login/view.dart';

import 'cubit.dart';
import 'states.dart';

class OnBoardingView extends StatelessWidget {
  const OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnBoardingCubit(),
      child: BlocBuilder<OnBoardingCubit, OnBoardingState>(
        builder: (context, state) {
          final onBoardingCubit = BlocProvider.of<OnBoardingCubit>(context);
          return Scaffold(
            backgroundColor: ColorManager.bgColor,
            body: Container(
              height: 1.sh,
              width: 1.sw,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      onBoardingCubit.model[state.currentPage].image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: SizedBox(height: 50.h)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: onBoardingCubit.model[state.currentPage].title,
                          color: ColorManager.white,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          maxLines: 3,
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: CustomText(
                            text: onBoardingCubit
                                .model[state.currentPage].subTitle,
                            color: ColorManager.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w400,
                            maxLines: 3,
                          ),
                        ),
                        SizedBox(height: 90.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Padding(
              padding: EdgeInsets.all(20.h),
              child: state.currentPage == onBoardingCubit.model.length - 1
                  ? CustomElevated(
                      text: "Get Started",
                      press: () {
                        CacheHelper.saveIfNotFirstTime();
                        MagicRouter.navigateTo(
                          page: const LoginView(),
                          withHistory: false,
                        );
                      },
                      btnColor: ColorManager.mainColor,
                    )
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            onBoardingCubit.incrementPage();
                          },
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: ColorManager.white,
                          )),
                    ),
            ),
          );
        },
      ),
    );
  }
}
