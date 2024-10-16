import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/helpers/either_extension.dart';
import 'package:homez/features/appartment_details/data/model/create_chat_success.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/appartment_details/data/model/remove_favorite_model.dart';
import 'package:homez/features/chat/data/models/chats_model.dart' as ChatModel;

import 'package:homez/features/appartment_details/data/repo/apartment_repo.dart';
import 'package:homez/features/chat/data/repo/chat_repo.dart';
import 'package:homez/features/saved/data/repo/favorite_repo.dart';
import 'package:dartz/dartz.dart';
part 'appartment_details_state.dart';

class AppartmentDetailsCubit extends Cubit<AppartmentDetailsState> {
  AppartmentDetailsCubit(
      {required this.apartmentRepo,
      required this.favoriteRepo,
      required this.chatRepo})
      : super(AppartmentDetailsInitial());
  ApartmentRepo apartmentRepo;
  FavoriteRepo favoriteRepo;
  ChatRepo chatRepo;
  int currentPage = 0;
  PageController pageController = PageController();
  List<Map<String, dynamic>> apartmentIds = [];
  Iterable<Datum>? isAlreadyFavorite;
  Iterable<ChatModel.Datum>? hasAlreadyChats;
  void scrollToNextPage() {
    if (currentPage < 3) {
      // Assuming 4 images, update this number based on total images
      pageController.animateToPage(
        currentPage + 1,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      //emit(AppartmentDetailsPageChanged(currentPage: currentPage));
    }
  }

  void updateCurrentPage(int index) {
    currentPage = index;
    emit(AppartmentDetailsPageChanged(currentPage: index));
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

  Future<void> checkIfIsHasChat({required int apartmentId}) async {
    try {
      final apartmentIDs = await chatRepo.getChats();
      if (apartmentIDs.isRight()) {
        final rightValue = apartmentIDs.asRight();
        final matchingChats = rightValue.data!.chats!.data
            .where((chat) => chat.aparmentId == apartmentId);
        if (matchingChats.isNotEmpty) {
          hasAlreadyChats = matchingChats;
        } else {
          log('No chats Exists for apartmentId: $apartmentId');
          createChat(apartmentId: apartmentId);
        }
        emit(ChatStatusChanged(hasAlreadyChats: hasAlreadyChats!));
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> checkIfIsFavorite({required int id}) async {
    try {
      Either<Failure, FavoriteModel> favoritesIds =
          await favoriteRepo.getFavoriteData();
      if (favoritesIds.isRight()) {
        final rightValue = favoritesIds.asRight();
        isAlreadyFavorite = rightValue.data!.apartment!.data
            .where((element) => element.id == id);
        log("is Already Favorite :$isAlreadyFavorite");
        emit(FavoriteStatusChanged(isAlreadyFavorite: isAlreadyFavorite!));
      }
    } catch (e) {
      throw Exception(e);
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
        isAlreadyFavorite = rightValue.data!.apartment!.data
            .where((element) => element.id == id);
        log("is Already Favorite :${isAlreadyFavorite.toString()}");
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

  Future<void> getFavorite() async {
    try {
      final respone = await apartmentRepo.getFavorite();
      apartmentIds = respone;
      log(apartmentIds.toString());
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> createChat({required int apartmentId}) async {
    emit(CreateChatLoading());
    try {
      final response = await apartmentRepo.createChat(apartmentId: apartmentId);
      response.fold((l) => emit(CreateChatFailed()),
          (r) => emit(CreateChatSuccess(createChatSuccessful: r)));
    } catch (e) {
      emit(CreateChatFailed());
    }
  }
}
