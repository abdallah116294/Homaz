import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';

import '../data/models/data_search.dart';

class PropertyTypeWidget extends StatefulWidget {
  const PropertyTypeWidget({super.key, required this.onSelectionChanged,required this.categories});
  final Function(int)? onSelectionChanged;
  final Data categories;
  @override
  State<PropertyTypeWidget> createState() => _PropertyTypeWidgetState();
}

class _PropertyTypeWidgetState extends State<PropertyTypeWidget> {
  int _selectedIndex = -1;
  int? selectedDuration;

  final List<String> _chipLabels = [
    'Apartment',
    'Twinhouse  ',
    'Townhouse  ',
  ];
  int? _extractNumberFromLabel(String label) {
    final match = RegExp(r'\d+').firstMatch(label);
    return match != null ? int.parse(match.group(0)!) : null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        int selectedIndex = -1;
        if (state is PropertyTypeState) {
          selectedIndex = state.selectedIndex;
        }
        return Container(
          height: 100.h,
          width: 340.w,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: ColorManager.grey12,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                   "assets/icons/buildings.svg",
                    height: 15,
                    colorFilter:
                        ColorFilter.mode(ColorManager.grey12, BlendMode.srcIn),
                  ),
                  CustomText(
                      text: 'Property Type',
                      color: ColorManager.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp)
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //spacing: 10,
                  children: List<Widget>.generate(
                   widget.categories.categories.length,
                    (int index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ChoiceChip(
                          showCheckmark: false,
                          label: Text(
                            widget.categories.categories[index].name.toString(),
                            style: TextStyle(color: ColorManager.white),
                          ),
                          selected: _selectedIndex == index,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedIndex = selected ? index : -1;
                            });
                            if (widget.onSelectionChanged != null) {
                              widget.onSelectionChanged!(_selectedIndex);
                            }
                          },
                          selectedColor: Colors.blue,
                          backgroundColor: ColorManager.grey23,
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
