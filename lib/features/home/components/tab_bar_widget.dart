import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.tabs,
  });

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 43.h,
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            labelStyle:  TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              fontFamily: 'Regular',
            ),
            dividerColor: Colors.transparent,
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 10),
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle:  TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              fontFamily: 'Regular',
            ),
            tabs: tabs,
          ),
        ),
      ],
    );
  }
}
