import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/helpers/either_extension.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/data/model/remove_favorite_model.dart';
import 'package:homez/features/appartment_details/data/repo/apartment_repo.dart';
import 'package:homez/features/saved/data/repo/favorite_repo.dart';
import 'package:dartz/dartz.dart';
part 'appartment_details_state.dart';

class AppartmentDetailsCubit extends Cubit<AppartmentDetailsState> {
  AppartmentDetailsCubit(
      {required this.apartmentRepo, required this.favoriteRepo})
      : super(AppartmentDetailsInitial());
  ApartmentRepo apartmentRepo;
  FavoriteRepo favoriteRepo;
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
      Either<Failure, FavoriteModel> favoritesIds =
          await favoriteRepo.getFavoriteData();
      emit(AddToFavoriteLoading());
      if (favoritesIds.isRight()) {
        final rightValue = favoritesIds.asRight();
        final isAlreadyFavorite = rightValue.data!.apartment!.data
            .where((element) => element.id == id);
        log(isAlreadyFavorite.toString());
        emit(RemoveFromFavoriteLoading());
        if (isAlreadyFavorite != null) {
          final response = await apartmentRepo.removeFavorite(apartmentId: id);
          response.fold((l) => emit(RemoveFromFavoriteFailed()),
              (r) => emit(RemoveFromFavoriteSuccess(removeFavoriteModel: r)));
        } else {
          emit(AddToFavoriteLoading());
          final response = await apartmentRepo.addToFavoirte(apartmentId: id);
          response.fold((l) {
            if (l is ServerFailure) {
              log('Server Failure:${l.errMessage}');
            } else {
              log("An unknown error: $l");
            }
            emit(AddToFavoriteFailed());
          }, (r) {
            log('Add to Favorite Successfully');
            emit(AddToFavoriteSuccess(favoriteModel: r));
          });
        }
      }
    } catch (e) {
      emit(AddToFavoriteFailed());
    }
  }
}
