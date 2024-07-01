import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class CustomElevatedWithImage extends StatelessWidget {
  final String text, fontFamily, image;
  final Color btnColor, iconColor, fontColor;
  final double hSize, wSize, fontSize, borderRadius;
  final VoidCallback press;
  final FontWeight fontWeight;
  final bool haveIcon;

  const CustomElevatedWithImage({
    super.key,
    required this.text,
    required this.image,
    required this.press,
    required this.btnColor,
    required this.iconColor,
    required this.fontColor,
    this.hSize = 55,
    this.wSize = 1,
    this.fontSize = 14,
    this.borderRadius = 12,
    this.fontWeight = FontWeight.w400,
    this.fontFamily = "Regular",
    this.haveIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: press,
      style: ElevatedButton.styleFrom(
        backgroundColor: btnColor,
        elevation: 0,
        fixedSize: Size(wSize.sw, hSize.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CustomText(
                text: text,
                color: fontColor,
                fontSize: fontSize.sp,
                fontWeight: fontWeight,
              ),
            ),
          ),
          haveIcon
              ? Row(
                  children: [
                    SizedBox(width: 10.w),
                    SvgIcon(
                      icon: image,
                      color: iconColor,
                      height: 20.h,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
