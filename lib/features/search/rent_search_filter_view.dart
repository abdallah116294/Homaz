import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/features/search/widgets/amenities_widget.dart';
import 'package:homez/features/search/widgets/badrooms_widget.dart';
import 'package:homez/features/search/widgets/bathroom_filter.dart';
import 'package:homez/features/search/widgets/furnshied_fliter_widget.dart';
import 'package:homez/features/search/widgets/price_range_widget.dart';
import 'package:homez/features/search/widgets/property_type_widget.dart';

class RentSearchFilterView extends StatefulWidget {
  const RentSearchFilterView({super.key});

  @override
  State<RentSearchFilterView> createState() => _RentSearchFilterViewState();
}

class _RentSearchFilterViewState extends State<RentSearchFilterView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const PropertyTypeWidget(),
            SizedBox(height: 20.h),
            const BadRoomsFilterWidget(),
            SizedBox(height: 20.h),
            const BathroomFilterWidget(),
            SizedBox(height: 20.h),
            const FurnishedFilterWidget(),
            SizedBox(height: 20.h),
            const AmenitiesFilterWidget(),
            SizedBox(
              height: 20.h,
            ),
            const PriceRangeWidget(),
            SizedBox(
              height: 20.h,
            ),
            CustomElevated(
                text: 'Show All Results',
                press: () {},
                btnColor: ColorManager.mainColor)
          ],
        ),
      ),
    );
  }
}
