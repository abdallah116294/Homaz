import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/theming/assets.dart';

import 'model.dart';
import 'states.dart';

class OnBoardingCubit extends Cubit<OnBoardingState> {
  final List<OnBoardingModel> model = [
    OnBoardingModel(
      currentPage: 0,
      title: "Explore Amazing Real Estate ",
      image: AssetsStrings.onBoarding1,
      subTitle: "Find what you want ",
    ),
    OnBoardingModel(
      currentPage: 1,
      title: "Compare and choose  ",
      image: AssetsStrings.onBoarding2,
      subTitle: "Find what you want ",
    ),
    OnBoardingModel(
      currentPage: 2,
      title: "choose the more comfort",
      image: AssetsStrings.onBoarding3,
      subTitle: "Find what you want ",
    ),
  ];

  OnBoardingCubit() : super(OnBoardingState(currentPage: 0));

  void incrementPage() {
    if (state.currentPage < model.length - 1) {
      emit(OnBoardingState(currentPage: state.currentPage + 1));
    }
  }
}
