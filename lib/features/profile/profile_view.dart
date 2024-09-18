import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/helpers/cache_helper.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/appartment_details/screen/apartment_details_after_take_look.dart';
import 'package:homez/features/change_password/view.dart';
import 'package:homez/features/login/view.dart';
import 'package:homez/features/notification/notification_view.dart';
import 'package:homez/features/profile/profile_cubit.dart';
import 'package:homez/features/profile/widgets/change_lang_widget.dart';
import 'package:homez/features/profile/widgets/model_bottom_sheet.dart';
import 'package:homez/features/profile/widgets/profile_item.dart';
import 'package:homez/features/profile_details/profile_details.dart';
import 'package:homez/injection_container.dart' as di;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<ProfileCubit>(),
      child: const ProfileViewBody(),
    );
  }
}

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<ProfileCubit>(context);
    cubit.profileInfoData();
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileDataLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: ColorManager.mainColor,
            ),
          );
        }
        if (state is ProfileDataFailedState) {
          return CustomText(
            text: state.msg,
            color: ColorManager.red,
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
          );
        }
        var profileData = cubit.profileData!.data!.user;

        return Scaffold(
          backgroundColor: ColorManager.bgColor,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Column(
              children: [
                CustomAppBarTitle(
                  title: context.translate(LangKeys.myAccount),
                  withBack: false,
                ),
                30.verticalSpace,
                ListTile(
                  onTap: () {
                    MagicRouter.navigateTo(
                        page: ProfileDetailsView(
                          userData: profileData,
                      fullName: '${profileData.fullname}',
                      phone: '${profileData.phone}',
                    ));
                  },
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(profileData!.image!),
                    backgroundColor: ColorManager.mainColor,
                  ),
                  title: CustomText(
                    text: '${profileData.fullname}',
                    color: ColorManager.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                ),
                12.verticalSpace,
                ProfileItem(
                  icon: AssetsStrings.language,
                  text: "${context.translate(LangKeys.language)} ",
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                  //  log(prefs.toString());
                    ModalBottomSheet.changeLangueBottomSheet(context);
                  },
                ),
                ProfileItem(
                  icon: AssetsStrings.info,
                  text: context.translate(LangKeys.about),
                  onTap: () {},
                ),
                ProfileItem(
                  icon: AssetsStrings.rateUs,
                  text: context.translate(LangKeys.rateUs),
                  onTap: () {},
                ),
                ProfileItem(
                    icon: AssetsStrings.lock,
                    text: context.translate(LangKeys.changePassword),
                    haveTrailing: true,
                    onTap: () {
                      MagicRouter.navigateTo(
                        page: const ChangePasswordView(),
                      );
                    }),
                BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is LogOutSuccessState) {
                      MagicRouter.navigateTo(
                        page: const LoginView(),
                        withHistory: false,
                      );
                    }
                  },
                  child: ProfileItem(
                    icon: AssetsStrings.logOut,
                    text: context.translate(LangKeys.logOut),
                    haveTrailing: false,
                    onTap: () {
                      cubit.logOut();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
