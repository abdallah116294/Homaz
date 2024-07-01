import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class CustomAppBarTitle extends StatelessWidget {
  const CustomAppBarTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.h, bottom: 30.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              MagicRouter.navigatePop();
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                AssetsStrings.back,
                height: 30.h,
              ),
            ),
          ),
          const Spacer(),
          CustomText(
            text: title,
            color: ColorManager.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.w500,
          ),
          const Spacer(),
          SizedBox(width: 30.w),
        ],
      ),
    );
  }
}
