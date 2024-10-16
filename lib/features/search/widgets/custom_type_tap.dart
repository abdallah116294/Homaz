import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';

class CustomTabBarType extends StatelessWidget {
  const CustomTabBarType({
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
          height: 55.h,
          width: 219.w,
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
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
        SizedBox(height: 20.h),
        if (pages != null)
          Container(
            width: 428.w,
            height: 600.h,
            child: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: pages!,
            ),
          )
      ],
    );
  }
}
