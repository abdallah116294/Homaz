import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/data/repo/apartment_repo.dart';

part 'appartment_details_state.dart';

class AppartmentDetailsCubit extends Cubit<AppartmentDetailsState> {
  AppartmentDetailsCubit({required this.apartmentRepo})
      : super(AppartmentDetailsInitial());
  ApartmentRepo apartmentRepo;
  int currentPage = 0;
  PageController pageController = PageController();
  void scrollToNextPage() {
    if (currentPage < 3) {
      // Assuming 4 images, update this number based on total images
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void scrollToPreviousPage() {
    if (currentPage > 0) {
      pageController.animateToPage(
        currentPage - 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> addToFavorite({required int id}) async {
    emit(AddToFavoriteLoading());
    try {
      final response = await apartmentRepo.addToFavoirte(id: id);
      response.fold((l) {
        if (l is ServerFailure) {
          log('Server Failure:${l.errMessage}');
        } else {
          log("An unknown error: $l");
        }
        emit(AddToFavoriteFailed());
      }, (r) {
        emit(AddToFavoriteSuccess(favoriteModel: r));
      });
    } catch (e) {
      emit(AddToFavoriteFailed());
    }
  }
}
