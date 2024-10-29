import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              thickness: 0.0015.sh,
              color: ColorManager.grey10,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.042.sw),
            child: CustomText(
              text:context.translate(LangKeys.or_sign_with_social),
              color: ColorManager.grey10,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 0.0015.sh,
              color: ColorManager.grey10,
            ),
          ),
        ],
      ),
    );
  }
}
