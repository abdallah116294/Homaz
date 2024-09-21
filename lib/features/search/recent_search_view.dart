import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/colors.dart';
import 'package:homez/core/widgets/custom_text.dart';
import 'package:homez/features/search/cubit/search_cubit.dart';

class RecentSearchView extends StatelessWidget {
  const RecentSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        color: ColorManager.grey11,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomText(
                text: context.translate(LangKeys.history),
                color: ColorManager.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            const SizedBox(height: 10),
            BlocBuilder<SearchCubit,SearchState>(builder: (context, state) {
              if (state is GetRecentSearchSuccess) {
                return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          context.read<SearchCubit>().defulateSearch(keyword: state.recentSearchModel.data!.recentSearchHistory[index].keyword!);
                        },
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                context
                                    .read<SearchCubit>()
                                    .deleteRecentSearchById(
                                        id: state.recentSearchModel.data!
                                            .recentSearchHistory[index].id!);
                                context.read<SearchCubit>().fetchRecentSearch();
                              },
                              icon: Icon(
                                Icons.close,
                                color: ColorManager.white,
                              )),
                          title: CustomText(
                              text: state.recentSearchModel.data!
                                  .recentSearchHistory[index].keyword
                                  .toString(),
                              color: ColorManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: state
                        .recentSearchModel.data!.recentSearchHistory.length);
              } else {
                // return const  Center(
                //   child: CircularProgressIndicator(),
                // );
                final recentSearchModel =
                    context.read<SearchCubit>().recentSearchModel;
                return recentSearchModel==null?const Center(
                  child: CircularProgressIndicator(),
                ): ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          context.read<SearchCubit>().defulateSearch(keyword: recentSearchModel.data!.recentSearchHistory[index].keyword!);
                        },
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                context
                                    .read<SearchCubit>()
                                    .deleteRecentSearchById(
                                        id: recentSearchModel.data!
                                            .recentSearchHistory[index].id!);
                                context.read<SearchCubit>().fetchRecentSearch();
                              },
                              icon: Icon(
                                Icons.close,
                                color: ColorManager.white,
                              )),
                          title: CustomText(
                              text: recentSearchModel
                                  .data!.recentSearchHistory[index].keyword
                                  .toString(),
                              color: ColorManager.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount:
                        recentSearchModel.data!.recentSearchHistory.length);
              }
            }),
          ]),
        ),
      ),
    );
  }
}
