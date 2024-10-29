import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';

import 'cubit.dart';
import 'states.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
    bool isArabicSelected = false;
  @override
  void initState() {
    super.initState();
    final langCode = CacheHelper.get(key: "selected_language");
    isArabicSelected = langCode == 'ar'; 
  }
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
                      onBoardingCubit.getModel(context)[state.currentPage].image),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(100.w, 48.h),
                                backgroundColor: Colors.transparent,
                                side:
                                    const BorderSide(color: Color(0xffEFC3C3))),
                            onPressed: () {
                              context.read<AppCubit>().toggleLanguage();
                            },
                            child: Text(
                          "(${ context.translate(LangKeys.language)})",
                              style: TextStyle(
                                  color:const  Color(0xffEFC3C3), fontSize: 12.sp),
                            )),
                      ),
                    ),
                    Expanded(child: SizedBox(height: 50.h)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text:  onBoardingCubit.getModel(context)[state.currentPage].title,
                          color: ColorManager.white,
                          fontSize: 34.sp,
                          fontWeight: FontWeight.w800,
                          maxLines: 3,
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: CustomText(
                            text:  onBoardingCubit.getModel(context)[state.currentPage].subTitle,
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
              child: state.currentPage ==  onBoardingCubit.getModel(context).length - 1
                  ? CustomElevated(
                      text: context.translate(LangKeys.get_started),
                      press: () {
                        CacheHelper.saveIfNotFirstTime();
                        context.pushName(AppRoutes.loginView);
                      },
                      btnColor: ColorManager.mainColor,
                    )
                  : Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                          onPressed: () {
                            onBoardingCubit.incrementPage(context);
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
