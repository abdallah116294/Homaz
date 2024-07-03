import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.image,
    required this.text,
  });

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: () {},
        leading: CircleAvatar(
          radius: 26.r,
          backgroundColor: ColorManager.mainColor,
        ),
        title: CustomText(
          text: text,
          color: ColorManager.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w400,
          maxLines: 2,
        ),
        trailing: const Icon(
          Icons.more_horiz_outlined,
          color: Colors.white,
        ),
      ),
    );
  }
}
