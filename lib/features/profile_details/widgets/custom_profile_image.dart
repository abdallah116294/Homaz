import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';

class CustomProfileImageWidget extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageChange;

  const CustomProfileImageWidget({
    Key? key,
    required this.imageUrl,
    required this.onImageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight, // Icon will be placed at the bottom right of the image
      children: [
        Container(
          height: 130.h,
          width: 130.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorManager.mainColor,
              width: 3.w,
            ),
          ),
          child: ClipOval(
           // borderRadius: BorderRadius.circular(50.h),
            child: context.read<ProfileDetailsCubit>().pickedImage != null
                ? Image(
                    image: FileImage(
                      File(context.read<ProfileDetailsCubit>().pickedImage!.path),
                    ),
                    fit: BoxFit.cover,
                  )
                : imageUrl != null && imageUrl!.isNotEmpty
                    ? CachedNetworkImage(imageUrl: imageUrl!,fit: BoxFit.cover,)
                    : SvgPicture.asset(
                        'assets/icons/user.svg',
                        fit: BoxFit.cover,
                      ),
          ),
        ),
        // Icon to change the image
        Positioned(
          bottom: 5,
          right: 5,
          child: GestureDetector(
            onTap: onImageChange, // Call the function to change image
            child: Container(
               height: 40.h,
          width: 40.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorManager.mainColor,
              width: 1.w,
            ),
          ),
              child: CircleAvatar(
                backgroundColor: ColorManager.bgColor,
                radius: 15.w,
                child: SvgIcon(color:ColorManager.mainColor ,
                icon: "assets/icons/edit_profile.svg",
               height: 30.h,
                  
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
