import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/features/notification/widgets/notification_item.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            const CustomAppBarTitle(
              title: "Notifications",
            ),
            30.verticalSpace,
            const NotificationItem(
              image: "",
              text: "ZI company posted new",
            ),
            const NotificationItem(
              image: "",
              text: "Johan viewed your",
            ),
            const NotificationItem(
              image: "",
              text: "ZI company posted new",
            ),
            const NotificationItem(
              image: "",
              text: "ZI company posted new",
            ),
          ],
        ),
      ),
    );
  }
}
