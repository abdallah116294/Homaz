import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({
    super.key,
    required this.title,
    this.color,
    this.withBack = true,
  });

  final String title;
  final Color? color;
  final bool withBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      child: Row(
        children: [
          withBack
              ? GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Align(
                    alignment: context.read<AppCubit>().getAlignment(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 30.sp,
                     // height: 30.h,
                      color: color ?? ColorManager.white,
                    ),
                  ),
                )
              : const SizedBox(),
          const Spacer(),
          CustomText(
            text: title,
            color: color ?? ColorManager.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
          ),
          const Spacer(),
          SizedBox(width: 30.w),
        ],
      ),
    );
  }
}
