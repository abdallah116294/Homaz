import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_elevated.dart';
import 'package:homez/core/widgets/custom_tab_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/svg_icons.dart';
import 'package:homez/features/app/cubit/app_cubit.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/injection_container.dart' as di;
import 'package:url_launcher/url_launcher.dart';
import '../data/model/home_success_model.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class MainTabsWithBody extends StatelessWidget {
  const MainTabsWithBody({super.key, required this.homeData});

  final Data homeData;
  Future<void> _launchSocialMediaAppIfInstalled({
  required String url,
  }) async {
  try {
    bool launched = await launch(url, forceSafariVC: false); // Launch the app if installed!

    if (!launched) {
      await launch(url); // Launch web view if app is not installed!
    }
  } on Exception catch (e) {
    launch(url); // Launch web view if app is not installed!
  }
}
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: homeData.apartmentTypes.length,
      child: Column(
        children: [
          CustomTabBar(
            tabs: List.generate(
              homeData.apartmentTypes.length,
              (index) {
                final apartmentType = homeData.apartmentTypes[index];
                return CustomText(
                  text: "${apartmentType.name}",
                  color: ColorManager.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 16.sp,
                );
              },
            ),
            isScrollable: false,
          ),
          // CustomBuyWidget(
          //   pages: homeData.apartments!,
          // ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: SizedBox(
              height: 0.6.sh,
              child: Swiper(
                itemBuilder: (context, index) {
                  final apartment = homeData.apartments[index];

                  return ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Stack(
                  children: [
                    Image.network(
                      "${homeData.apartments[index].mainImage}",
                      fit: BoxFit.cover,
                      height: 0.6.sh,
                    ),
                    Positioned(
                      right: 18,
                      bottom: 20,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 38.h,
                            width: 141.w,
                            child: CustomElevated(
                              borderRadius: 8.sp,
                              text: context.translate(LangKeys.takeALook),
                              press: () {
                                print("${homeData.apartments[index].id}");
                                context.pushName(AppRoutes.takeALookView,
                                    arguments:
                                        homeData.apartments[index].id);
                              },
                              btnColor: ColorManager.mainColor,
                            ),
                          ),
                          8.horizontalSpace,
                          GestureDetector(
                            onTap: () async {
                             _launchSocialMediaAppIfInstalled(url: apartment.mainImage.toString());
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: ColorManager.blueColor,
                              child: const SvgIcon(
                                icon: AssetsStrings.out,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // BlocBuilder<AppartmentDetailsCubit,
                    //     AppartmentDetailsState>(
                    //   builder: (context, state) {
                    //     return state is FavoriteStatusChanged
                    //         ? Positioned(
                    //             right: 25,
                    //             top: 30,
                    //             child: GestureDetector(
                    //               onTap: () {
                    //                 context
                    //                     .read<AppartmentDetailsCubit>()
                    //                     .addToFavorite(
                    //                         id: homeData
                    //                             .apartments[index].id!);
                    //               },
                    //               child: CircleAvatar(
                    //                 radius: 20,
                    //                 backgroundColor: Colors.black,
                    //                 child: SvgIcon(
                    //                   // icon:hom
                    //                   icon: state.isAlreadyFavorite
                    //                           .isNotEmpty
                    //                       ? AssetsStrings.heartFillRed
                    //                       : AssetsStrings.favorite,
                    //                   color: state.isAlreadyFavorite
                    //                           .isNotEmpty
                    //                       ? Colors.red
                    //                       : Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           )
                    //         : Positioned(
                    //             right: 25,
                    //             top: 30,
                    //             child: GestureDetector(
                    //               onTap: () {
                    //                 context
                    //                     .read<AppartmentDetailsCubit>()
                    //                     .addToFavorite(
                    //                         id: homeData
                    //                             .apartments[index].id!)
                    //                     .then((value) {
                    //                   context
                    //                       .read<AppartmentDetailsCubit>()
                    //                       .checkIfIsFavorite(
                    //                           id: homeData
                    //                               .apartments[index].id!);
                    //                 });
                    //               },
                    //               child: CircleAvatar(
                    //                 radius: 20,
                    //                 backgroundColor: Colors.black,
                    //                 child: SvgIcon(
                    //                   icon: AssetsStrings.favorite,
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           );
                    //   },
                    // ),
                  ],
                                        ),
                                      );
                },
                itemCount: homeData.apartments.length,
                itemWidth: 0.8.sw,
                layout: SwiperLayout.STACK,
                // loop: false,
                // autoplay: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ApartmentCard extends StatelessWidget {
  const ApartmentCard({super.key, required this.apartment});

  final Apartment apartment;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.network(
            "${apartment.mainImage}",
            fit: BoxFit.cover,
            height: 0.6.sh,
          ),
          Positioned(
            right: 18,
            bottom: 20,
            child: Row(
              children: [
                SizedBox(
                  height: 38.h,
                  width: 141.w,
                  child: CustomElevated(
                    borderRadius: 8.sp,
                    text: context.translate(LangKeys.takeALook),
                    press: () {
                      context.pushName(
                        AppRoutes.takeALookView,
                        arguments: apartment.id,
                      );
                    },
                    btnColor: ColorManager.mainColor,
                  ),
                ),
                8.horizontalSpace,
                CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorManager.blueColor,
                  child: const SvgIcon(
                    icon: AssetsStrings.out,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          BlocListener<AppartmentDetailsCubit, AppartmentDetailsState>(
            listener: (context, state) {
              if (state is FavoriteStatusChanged) {
                // Optionally show a message here if needed.
              }
            },
            child: Positioned(
              right: 25,
              top: 30,
              child: GestureDetector(
                onTap: () {
                  context
                      .read<AppartmentDetailsCubit>()
                      .addToFavorite(id: apartment.id!)
                      .then((value) {
                    // context
                    //     .read<AppartmentDetailsCubit>()
                    //     .checkIfIsFavorite(id: apartment.id!);
                  });
                },
                child:
                    BlocBuilder<AppartmentDetailsCubit, AppartmentDetailsState>(
                  builder: (context, state) {
                    bool isFavorite = context
                            .read<AppartmentDetailsCubit>()
                            .isAlreadyFavorite ==
                        true;

                    return CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black,
                      child: SvgIcon(
                        icon: isFavorite
                            ? AssetsStrings.heartFillRed
                            : AssetsStrings.favorite,
                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
