import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/saved/cubit/favorite_cubit.dart';
import 'package:homez/injection_container.dart' as di;
import 'widgets/saved_item.dart';

class SavedView extends StatefulWidget {
  const SavedView({super.key});

  @override
  State<SavedView> createState() => _SavedViewState();
}

class _SavedViewState extends State<SavedView> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    final favoircubit = context.read<FavoriteCubit>();
     super.build(context);
    return BlocProvider(
      create: (context) => di.sl<FavoriteCubit>()..fetchFavoriteData(),
      child: BlocConsumer<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is RemoveFromFavoriteSuccessFav) {
            showMessage(
              message: 'Removed from Favorite Successfully',
              color: ColorManager.blue,
            );
            //favoircubit.fetchFavoriteData();
          } else if (state is RemoveFromFavoriteFailedFav) {
            showMessage(
              message: 'Error removing from Favorite',
              color: ColorManager.red,
            );
          }
        },
        builder: (context, state) {
          if (state is GetFavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFavoriteSuccess) {
            final apartments = state.apartments;
            return Scaffold(
              backgroundColor: ColorManager.bgColor,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Column(
                  children: [
                    CustomAppBarTitle(
                      title: context.translate(LangKeys.saved),
                      withBack: false,
                    ),
                    10.verticalSpace,
                    apartments.isEmpty
                        ? Center(
                            child: CustomText(
                              text: context.translate(LangKeys.you_dont_have_favorite),
                              color: ColorManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          )
                        : Expanded(
                            child: NotificationListener<ScrollNotification>(
                              onNotification: (notification) {
                                if (notification.metrics.pixels ==
                                        notification.metrics.maxScrollExtent &&
                                    state.hasMore &&
                                    !state.isLoadingMore) {
                                  favoircubit.fetchFavoriteData();
                                  return true;
                                }
                                return false;
                              },
                              child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 10.h),
                                itemCount: apartments.length,
                                itemBuilder: (context, index) {
                                  final apartment = apartments[index];
                                  return GestureDetector(
                                    onTap: () {
                                      context.pushName(
                                        AppRoutes.apartmentDetailsView,
                                        arguments: {
                                          "apartmentId": apartment.id
                                        },
                                      );
                                    },
                                    child: SavedItem(
                                      oTap: () async {
                                        favoircubit
                                            .removFromFavoirte(
                                                id: apartment.id!)
                                            .then((value) {
                                          context.read<FavoriteCubit>().fetchFavoriteData();
                                        });
                                      },
                                      apartment: apartment,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          } else if (state is GetFavoriteFailed) {
            return Scaffold(
              backgroundColor: ColorManager.bgColor,
              body: Center(child: Text(state.message)),
            );
          } else {
            return Scaffold(
              backgroundColor: ColorManager.bgColor,
              body: const Center(child: Text('No favorites found.')),
            );
          }
        },
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
