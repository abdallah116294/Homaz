import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/features/search/rent_search_filter_view.dart';
import 'package:homez/features/search/widgets/custom_type_tap.dart';

class SearchFilterView extends StatefulWidget {
  SearchFilterView({super.key, required this.searchController});
  TextEditingController searchController;
  @override
  State<SearchFilterView> createState() => _SearchFilterViewState();
}

class _SearchFilterViewState extends State<SearchFilterView> {
  TextEditingController searchController = TextEditingController();
  String searchString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 30,),
          child: Column(children: [
            SizedBox(height: 20.h),
            CustomText(
                text:context.translate(LangKeys.search_filter),
                color: ColorManager.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp),
            //SizedBox(height: 20.h),
            SearchTextField(
              hint: context.translate(LangKeys.search),
              controller: searchController,
              onFieldSubmitted: (String value) {
                setState(() {
                  searchString = value;
                });
                log(searchString);
              },
            ),
            SizedBox(height: 12.h),
            DefaultTabController(
                length: 2,
                child: SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        CustomTabBarType(
                          pages: [
                            // First page for "Rent"
                            RentSearchFilterView(
                              searchString: searchString,
                              index: 1,
                            ),
                            // Second page for "Buy"
                            RentSearchFilterView(
                              searchString: searchString,
                              index: 2,
                            ),
                          ],
                          tabs: [
                            CustomText(
                              text: context.translate(LangKeys.rent),
                              color: ColorManager.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                            CustomText(
                              text: context.translate(LangKeys.buy),
                              color: ColorManager.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 16.sp,
                            ),
                          ],
                          isScrollable: true,
                        ),
                      ],
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }
}
