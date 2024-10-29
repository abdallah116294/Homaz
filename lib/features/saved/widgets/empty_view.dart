import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.image, required this.title, required this.subTitle});
  final String image, title, subTitle;
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
           image,
            height: 282.h,
            width: 306,
          ),
          SizedBox(height: 36.h),
          CustomText(
              text: title,
              color: ColorManager.white,
              fontWeight: FontWeight.w600,
              fontSize: 28.sp),
          SizedBox(
            height: 12.h,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 26, left: 26),
            child: CustomText(
                text:subTitle,
                maxLines: 2,
                color: ColorManager.white,
                fontWeight: FontWeight.w400,
                fontSize: 12.sp),
          )
        ]);
  }
}
