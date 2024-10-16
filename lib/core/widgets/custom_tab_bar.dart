import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/circle_image.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.isScrollable,
    this.pages,
  });

  final List<Widget> tabs;
  final List<Widget>? pages;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
              color: ColorManager.bgColor,
              border: Border.all(
                color: ColorManager.grey10,
                width: 1.w,
              ),
              borderRadius: BorderRadius.circular(12)),
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: Colors.transparent,
            labelStyle:
                 TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: ColorManager.mainColor,
            ),
            dividerColor: Colors.transparent,
            isScrollable: isScrollable,
            labelPadding: const EdgeInsets.symmetric(horizontal: 20),
            unselectedLabelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            tabs: tabs,
          ),
        ),
        if (pages != null)
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: pages!,
            ),
          )
      ],
    );
  }
}
