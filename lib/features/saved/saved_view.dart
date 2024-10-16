import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
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

class _SavedViewState extends State<SavedView> {
  @override
  Widget build(BuildContext context) {
    final favoircubit = context.read<FavoriteCubit>();
    return BlocProvider(
      create: (context) => di.sl<FavoriteCubit>()..fetchFavoriteData(),
      child: BlocConsumer<FavoriteCubit, FavoriteState>(
        listener: (context, state) {
          if (state is RemoveFromFavoriteSuccessFav) {
            showMessage(
                message: 'Remove From Favorite Successfully',
                color: ColorManager.blue);
          } else if (state is RemoveFromFavoriteFailedFav) {
            showMessage(
                message: 'Error Remove From Favorite', color: ColorManager.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorManager.bgColor,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  const CustomAppBarTitle(
                    title: "Saved",
                    withBack: false,
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: BlocBuilder<FavoriteCubit, FavoriteState>(
                      builder: (context, state) {
                        if (state is GetFavoriteLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is GetFavoriteSuccess) {
                          final apartments = state.apartments;
                          return NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              if (notification.metrics.pixels ==
                                      notification.metrics.maxScrollExtent &&
                                  state.hasMore &&
                                  !state.isLoadingMore) {
                                context
                                    .read<FavoriteCubit>()
                                    .fetchFavoriteData();
                                return true;
                              } else {
                                return false;
                              }
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) => SizedBox(
                                height: 10.h,
                              ),
                              itemCount: apartments.length +
                                  1, // Add 1 for the loading indicator
                              itemBuilder: (context, index) {
                                if (index < apartments.length) {
                                  print(index);
                                  final apartment = apartments[index];

                                  return apartments.isEmpty
                                      ? CustomText(
                                          text:
                                              'You don\'t add Apartment to Favorite',
                                          color: ColorManager.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.sp)
                                      : GestureDetector(
                                          onTap: () {
                                            context.pushName(
                                                AppRoutes.apartmentDetailsView,
                                                arguments: {
                                                  "apartmentId": apartment.id,
                                                  //"takeLookData": Null
                                                });
                                          },
                                          child: SavedItem(
                                            oTap: () async {
                                              favoircubit.removFromFavoirte(
                                                  id: apartment.id!);
                                              if (mounted) {
                                                favoircubit.fetchFavoriteData();
                                              }
                                            },
                                            apartment: apartment,
                                          ),
                                        );
                                } else {
                                  print(index);
                                  return state.hasMore
                                      ? const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        )
                                      : const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Center(
                                              child:
                                                  CircularProgressIndicator()),
                                        );
                                }
                              },
                            ),
                          );
                        } else if (state is GetFavoriteFailed) {
                          return Center(child: Text(state.message));
                        } else {
                          return const Center(
                              child: Text('No favorites found.'));
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
