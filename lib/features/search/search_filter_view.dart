import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/features/search/rent_search_filter_view.dart';
import 'package:homez/features/search/widgets/custom_type_tap.dart';

class SearchFilterView extends StatefulWidget {
  const SearchFilterView({super.key});

  @override
  State<SearchFilterView> createState() => _SearchFilterViewState();
}

class _SearchFilterViewState extends State<SearchFilterView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(children: [
        CustomText(
            text: 'Search Filter',
            color: ColorManager.white,
            fontWeight: FontWeight.bold,
            fontSize: 14),
        SizedBox(height: 20.h),
        const SearchTextField(
          hint: 'Search',
        ),
        SizedBox(height: 12.h),
        DefaultTabController(
            length: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTabBarType(
                    pages: [
                      // First page for "Rent"
                      RentSearchFilterView(),
                      // Second page for "Buy"
                      Center(
                        child: CustomText(
                          text: 'Buy Page Content',
                          color: ColorManager.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    tabs: [
                      Column(children: [
                        CustomText(
                            text: 'Rent\t\t\t\t',
                            color: ColorManager.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                      ]),
                      Column(children: [
                        CustomText(
                            text: 'Buy',
                            color: ColorManager.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp)
                      ]),
                    ],
                    isScrollable: true,
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
