import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/svg_icons.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.hint = "Search",
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.controller,
    this.onFieldSubmitted,
    this.onChanged,
    this.onPressed,
  });

  final String hint;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool autofocus;
  final TextEditingController? controller;
  final Function(String)? onFieldSubmitted;
  final Function(String)? onChanged;
  final VoidCallback? onPressed;


  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    return GestureDetector(
      onTap: () {
        focusNode.unfocus();
      },
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        onTap: onTap,
        readOnly: readOnly,
        autofocus: autofocus,
        onFieldSubmitted: (value) {
          focusNode.unfocus();
          if (onFieldSubmitted != null &&
              controller!.text.trim().isNotEmpty) {
            onFieldSubmitted!(value);
          }
        },
        onChanged: onChanged,
        style: TextStyle(
          color: ColorManager.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          hintText: hint,
          suffixIconColor:ColorManager.grey10 ,
          suffixIcon: IconButton(onPressed: (){
            onPressed!();
          }, icon:const  Icon(Icons.filter_alt_outlined,size: 30,)),
          hintStyle: TextStyle(
            color: ColorManager.grey1,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.only(right: 5.w, left: 5.w),
          prefixIcon: Padding(
            padding: EdgeInsets.all(0.015.sh),
            child: SvgIcon(
              icon: AssetsStrings.search,
              height: 30.h,
              color: ColorManager.white,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              width: 0.001.sh,
              color: ColorManager.grey11,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.r),
            borderSide: BorderSide(
              width: 0.001.sh,
              color: ColorManager.grey11,
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0.001.sh,
                color: ColorManager.grey11,
              ),
              borderRadius: BorderRadius.circular(16.r)),
        ),
      ),
    );
  }
}
