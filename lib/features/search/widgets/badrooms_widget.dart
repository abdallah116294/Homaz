import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class BadRoomsFilterWidget extends StatefulWidget {
  const BadRoomsFilterWidget({super.key,required this.onSelectionChanged});
  final Function(int)? onSelectionChanged;
  @override
  State<BadRoomsFilterWidget> createState() => _BadRoomsFilterWidgetState();
}

class _BadRoomsFilterWidgetState extends State<BadRoomsFilterWidget> {
  int _selectedIndex = -1;
  int? selectedDuration;

  final List<String> _chipLabels = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6+",

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
            child: Row(
              children: [
                SvgPicture.asset(
                  AssetsStrings.bed,
                  height: 22,
                  colorFilter:
                      ColorFilter.mode(ColorManager.white, BlendMode.srcIn),
                ),
                SizedBox(width: 10.w),
                CustomText(
                    text: 'BadRooms',
                    color: ColorManager.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp)
              ],
            ),
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
                      shape: CircleBorder(
                        side: BorderSide(
                          color: ColorManager.grey12,
                        ),
                      ),
                      label: Text(
                        _chipLabels[index],
                        style: TextStyle(color: ColorManager.white),
                      ),
                      selected: _selectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedIndex = selected ? index : -1;
                        });
                         if(widget.onSelectionChanged!=null){
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
  }
}
