import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        SearchTextField(
          hint: 'Search',
          controller: widget.searchController
          
          ,
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
                      RentSearchFilterView(searchString: widget.searchController.text,index: 1,),
                      // Second page for "Buy"
                      RentSearchFilterView(searchString: widget.searchController.text,index: 2,),
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
