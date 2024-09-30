
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/models/profile_data_model.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/profile_details/profile_details_cubit.dart';
import 'package:homez/features/profile_details/widgets/custom_profile_image.dart';
import 'package:homez/features/profile_details/widgets/name_text_field_widget.dart';
import 'package:homez/features/profile_details/widgets/phone_text_field_widget.dart';
import 'package:homez/features/profile_details/widgets/save_button_widget.dart';
import 'package:homez/injection_container.dart' as di;
import 'package:image_picker/image_picker.dart';

class ProfileDetailsView extends StatelessWidget {
  const ProfileDetailsView({
    super.key,
    required this.fullName,
    required this.phone,
    required this.userData,
    this.navigateFromProfile = false,
  });

  final String fullName;
  final String phone;
  final bool navigateFromProfile;
  final User userData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProfileDetailsCubit>(),
      child: ProfileDetailsBody(
        fullName: fullName,
        phone: phone,
        navigateFromProfile: navigateFromProfile,
        userData: userData,
      ),
    );
  }
}

class ProfileDetailsBody extends StatelessWidget {
  const ProfileDetailsBody({
    super.key,
    required this.fullName,
    required this.phone,
    required this.navigateFromProfile,
    required this.userData,
  });

  final String fullName;
  final String phone;
  final bool navigateFromProfile;
  final User userData;

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileDetailsCubit>(context);
    cubit.controllers.nameController.text = fullName;
    cubit.controllers.phoneController.text = phone;
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: cubit.formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                CustomAppBarTitle(
                  title: context.translate(LangKeys.account_details),
                  withBack: true,
                ),
                30.verticalSpace,
                BlocBuilder<ProfileDetailsCubit, ProfileDetailsState>(
                  builder: (context, state) {
                    return CustomProfileImageWidget(
                        imageUrl: userData.image, onImageChange: () {
                              context
                                  .read<ProfileDetailsCubit>()
                                  .pickImage(ImageSource.gallery);
                        });
                
                  },
                ),
                30.verticalSpace,
                NameTextField(
                  cubit: cubit,
                ),
                SizedBox(height: 32.h),
                PhoneTextField(
                  cubit: cubit.controllers.phoneController.text.isEmpty
                      ? cubit
                      : cubit,
                ),
                SizedBox(height: 32.h),
                SaverButton(
                  phoneNumber: phone,
                  cubit: cubit,
                  fullName: fullName,
                  navigateFromProfile: navigateFromProfile,
                  image: context.read<ProfileDetailsCubit>().pickedImage,
                ),
               SizedBox(height: 150.h),
                CustomText(text: 'Delete ACC', color: ColorManager.red, fontWeight: FontWeight.w400, fontSize: 14.sp),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: ColorManager.bgColor,
    );
  }
}
