part of 'appartment_details_cubit.dart';

sealed class AppartmentDetailsState extends Equatable {
  const AppartmentDetailsState();

  @override
  List<Object> get props => [];
}

final class AppartmentDetailsInitial extends AppartmentDetailsState {}
class AddToFavoriteLoading extends AppartmentDetailsState{}
class AddToFavoriteSuccess extends AppartmentDetailsState{
 final FavoriteModel  favoriteModel;
  AddToFavoriteSuccess({required this.favoriteModel});
}
class AddToFavoriteFailed extends AppartmentDetailsState{}