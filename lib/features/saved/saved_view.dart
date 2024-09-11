import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:homez/core/helpers/navigator.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_app_bar.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/appartment_details/cubit/appartment_details_cubit.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/screen/appartment_details.dart';
import 'package:homez/features/details/details_view.dart';
import 'package:homez/features/saved/cubit/favorite_cubit.dart';
import 'package:homez/injection_container.dart' as di;
import 'widgets/saved_item.dart';

class SavedView extends StatelessWidget {
  const SavedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<FavoriteCubit>()..fetchFavoriteData(),
      child: Scaffold(
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
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is GetFavoriteSuccess) {
                      final apartments = state.apartments;
                      return NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.pixels ==
                                  notification.metrics.maxScrollExtent &&
                              state.hasMore &&
                              !state.isLoadingMore) {
                            context.read<FavoriteCubit>().fetchFavoriteData();
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
                            if (index < apartments.length&&index==0) {
                              print(index);
                              final apartment = apartments[index];

                              return apartments.isEmpty?CustomText(text: 'You don\'t add Apartment to Favorite', color: ColorManager.white, fontWeight: FontWeight.bold, fontSize: 18.sp): GestureDetector(
                                onTap: () {
                                  MagicRouter.navigateTo(
                                    page: ApartmentDetailsScreen(
                                      apartmentId: apartment.id,
                                    ),
                                  );
                                },
                                child: SavedItem(
                                  oTap: () {
                                    context
                                        .read<FavoriteCubit>()
                                        .removFromFavoirte(id: apartment.id!)
                                        .then((onValue) {
                                      context
                                          .read<FavoriteCubit>()
                                          .fetchFavoriteData();
                                    });
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
                                          child: CircularProgressIndicator()),
                                    )
                                  : const  Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child:Center(
                                          child: CircularProgressIndicator()),
                                    );
                            }
                          },
                        ),
                      );
                    } else if (state is GetFavoriteFailed) {
                      return Center(child: Text(state.message));
                    } else {
                      return const Center(child: Text('No favorites found.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
