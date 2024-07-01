import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class CustomContainerIcon extends StatelessWidget {
  const CustomContainerIcon({
    super.key,
    required this.containerColor,
    required this.iconColor,
    required this.icon,
    this.size = 50,
    this.paddingIcon = 12,
  });

  final Color containerColor, iconColor;
  final String icon;
  final double size, paddingIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.h,
      width: size.h,
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(paddingIcon),
        child: SvgIcon(
          icon: icon,
          height: 12.h,
          color: iconColor,
        ),
      ),
    );
  }
}
