import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/saved/widgets/saved_item.dart';
import 'package:homez/features/search/data/models/search_result_model.dart';
import 'package:homez/features/search/widgets/search_result_widget.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.apartment});
  final Apartment apartment;
  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.bgColor,
      appBar: AppBar(
        backgroundColor: ColorManager.bgColor,
        title: CustomText(
            text: 'Search Results',
            color: ColorManager.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.sp),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: ColorManager.white,
            )),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                  text: '${widget.apartment.data.length} Properties',
                  color: ColorManager.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp),
              SizedBox(
                height: 10.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.apartment.data.length,
                itemBuilder: (context, index) {
                  return SearchResultItemWidget(
                      apartment: widget.apartment.data[index], oTap: () {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
