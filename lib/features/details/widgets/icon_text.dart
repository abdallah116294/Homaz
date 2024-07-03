import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class RowIconTextWidget extends StatelessWidget {
  const RowIconTextWidget({super.key, required this.icon, required this.text});

  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgIcon(
          icon: icon,
          color: ColorManager.white,
          height: 25,
        ),
        10.horizontalSpace,
        Expanded(
          child: CustomText(
            text: text,
            color: ColorManager.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
