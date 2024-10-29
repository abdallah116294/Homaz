import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/extensions/context.extensions.dart';
import 'package:homez/core/localization/lang_keys.dart';
import 'package:homez/core/theming/assets.dart';

import 'model.dart';
import 'states.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
   List<OnBoardingModel> getModel(BuildContext context) {
    return [
      OnBoardingModel(
        currentPage: 0,
        title: context.translate(LangKeys.explor_amazing_real_Estate),
        image: AssetsStrings.onBoarding1,
        subTitle:context.translate(LangKeys.find_what_you_want),
      ),
      OnBoardingModel(
        currentPage: 1,
        title: context.translate(LangKeys.compare_and_chose),
        image: AssetsStrings.onBoarding2,
        subTitle: context.translate(LangKeys.find_what_you_want),
      ),
      OnBoardingModel(
        currentPage: 2,
        title: context.translate(LangKeys.chose_more_comfort),
        image: AssetsStrings.onBoarding3,
        subTitle: context.translate(LangKeys.find_what_you_want),
      ),
    ];
  }
  OnBoardingCubit() : super(OnBoardingState(currentPage: 0));

  void incrementPage(context) {
    if (state.currentPage < getModel(context).length - 1) {
      emit(OnBoardingState(currentPage: state.currentPage + 1));
    }
  }
}
