import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/config/routes/app_routes.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/search_text_field.dart';
import 'package:homez/core/widgets/snack_bar.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';
import 'package:homez/features/search/recent_search_view.dart';
import 'package:homez/features/search/widgets/model_bottom_sheet.dart';
import 'package:homez/features/search/widgets/serch_item_widget.dart';
import 'package:homez/injection_container.dart' as di;

class DefaultSearchView extends StatefulWidget {
  const DefaultSearchView({super.key});

  @override
  State<DefaultSearchView> createState() => _DefaultSearchViewState();
}

class _DefaultSearchViewState extends State<DefaultSearchView> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => di.sl<SearchCubit>()..fetchRecentSearch(),
      child: BlocConsumer<SearchCubit, SearchState>(
        listener: (context, state) {
          log("Current state: $state");
          if (state is AddToFavoriteSuccess) {
            showMessage(
                message: "Add to Favorite Successful",
                color: ColorManager.blueColor);
          } else if (state is AddToFavoriteFailed) {
            showMessage(
                message: "Add to Favorite Failed", color: ColorManager.red);
          }
        },
        builder: (context, state) {
          return Scaffold(
              backgroundColor: ColorManager.bgColor,
              body: SafeArea(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            width: size.width * .7,
                            color: ColorManager.bgColor,
                            child: SearchTextField(
                              hint: context.translate(LangKeys.search),
                              controller: searchController,
                              onFieldSubmitted: (value) {
                                context
                                    .read<SearchCubit>()
                                    .defulateSearch(keyword: value);
                              },
                            )),
                        Center(
                          child: IconButton(
                              onPressed: () {
                                context.pushName(AppRoutes.searchFilter,arguments: {
                                  "searchController":searchController
                                });
                                // ModalBottomSheet.searchFilter(context,searchController);
                              },
                              icon: const Icon(Icons.filter_alt_outlined)),
                        ),
                      ],
                    ),
                  ),
                  if (state is GetRecentSearchSuccess) ...[
                    const RecentSearchView(),
                  ] else if (state is DefaultSearchLoading) ...[
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ] else if (state is DefaultSearchSuccess) ...[
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return GestureDetector(
                              onTap: () {
                                context.pushName(AppRoutes.apartmentDetailsView,
                                    arguments: {
                                      "apartmentId": state.searchResultModel
                                          .data!.apartment!.data[index].id,
                                    });
                                // MagicRouter.navigateTo(
                                //     page: ApartmentDetailsScreen(
                                //   apartmentId: state.searchResultModel.data!
                                //       .apartment!.data[index].id!,
                                // ));
                              },
                              child: SearchItemWidget(
                                  oTap: () async {
                                    // Avoid passing context inside the callback
                                    await searchCubit.addToFavorite(
                                        id: state.searchResultModel.data!
                                            .apartment!.data[index].id!);

                                    if (mounted) {
                                      searchCubit.defulateSearch(
                                          keyword: searchController.text);
                                    }
                                  },
                                  data: state.searchResultModel.data!.apartment!
                                      .data[index]));
                        },
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        itemCount: state
                            .searchResultModel.data!.apartment!.data.length,
                      ),
                    ),
                  ] else ...[
                    const RecentSearchView(),
                  ]
                ]),
              ));
        },
      ),
    );
  }
}
