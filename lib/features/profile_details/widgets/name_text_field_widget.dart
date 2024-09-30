import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text_form_field.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';

class NameTextField extends StatelessWidget {
  const NameTextField({super.key, required this.cubit});

  final ProfileDetailsCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.nameController,
      prefixIcon: Padding(
        padding: EdgeInsets.all(0.0197.sh),
        child: SvgIcon(
          icon: AssetsStrings.user,
          height: 0.029.sh,
          color: ColorManager.grey10,
        ),
      ),
      hint: "Name",
      validator: (value) {
        if (value!.isEmpty) {
          return "Please Enter Your Name !";
        }
        return null;
      },
    );
  }
}
