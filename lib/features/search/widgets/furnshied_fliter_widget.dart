import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class FurnishedFilterWidget extends StatefulWidget {
  const FurnishedFilterWidget({super.key,required this.onSelectionChanged});
   final Function(int)? onSelectionChanged;
  @override
  State<FurnishedFilterWidget> createState() => _FurnishedFilterWidgetState();
}

class _FurnishedFilterWidgetState extends State<FurnishedFilterWidget> {
  int _selectedIndex = -1;
  int? selectedDuration;

  final List<String> _chipLabels = [
    'Furnished',
    'unFurnished',
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
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
      decoration: BoxDecoration(
        color: ColorManager.grey12,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgIcon(icon: 'assets/icons/furnshied.svg', color: ColorManager.white,height: 20.h,),
              SizedBox(width: 6.w,),
              CustomText(
                  text: context.translate(LangKeys.furnishing),
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
                        style: TextStyle(color: ColorManager.white,fontSize: 16.sp),
                      ),
                      selected: _selectedIndex == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedIndex = selected ? index : -1;
                        });
                         if(widget.onSelectionChanged!=null){
                           widget.onSelectionChanged!(_selectedIndex);
                         }
                        // setState(() {
                        //   selectedDuration =
                        //       _extractNumberFromLabel(_chipLabels[_selectedIndex])!;
                        // });
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
