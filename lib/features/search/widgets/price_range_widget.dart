import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/injection_container.dart' as di;

class PriceRangeWidget extends StatefulWidget {
  PriceRangeWidget({
    super.key,
    required this.onRangeSelected,
  });
   final Function(double min,double max) onRangeSelected;
  @override
  State<PriceRangeWidget> createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<SearchCubit>(),
      child: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return Container(
            height: 100.h,
            width: 340.w,
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
            decoration: BoxDecoration(
              color: ColorManager.grey12,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SvgIcon(icon: 'assets/icons/price_range.svg', color: ColorManager.white),
                    SizedBox(width: 6.w,),
                    CustomText(
                        text: 'Price Range ',
                        color: ColorManager.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp)
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                RangeSlider(
                  values: _currentRangeValues,
                  max: 100,
                  divisions: 5,
                  activeColor: ColorManager.white,
                  inactiveColor: ColorManager.grey12,
                  labels: RangeLabels(
                    _currentRangeValues.start.round().toString(),
                    _currentRangeValues.end.round().toString(),
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentRangeValues = values;
                       widget.onRangeSelected(values.start,values.end);
                    });
                  
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
