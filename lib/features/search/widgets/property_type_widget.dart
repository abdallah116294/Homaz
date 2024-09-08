import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class PropertyTypeWidget extends StatefulWidget {
  const PropertyTypeWidget({super.key});

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
                AssetsStrings.propertyTpe,
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
                _chipLabels.length,
                (int index) {
                  return Padding(
                    padding:  EdgeInsets.only(right: 10.w),
                    child: ChoiceChip(
                      showCheckmark: false,
                      label: Text(
                        _chipLabels[index],
                        style: TextStyle(color: ColorManager.white),
                      ),
                      selected: _selectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedIndex = selected ? index : -1;
                        });
                        setState(() {
                          selectedDuration =
                              _extractNumberFromLabel(_chipLabels[_selectedIndex])!;
                        });
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
  }
}
