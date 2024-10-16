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
class RemoveFromFavoriteLoading extends AppartmentDetailsState{}
class RemoveFromFavoriteSuccess extends AppartmentDetailsState{
  final RemoveFavoriteModel removeFavoriteModel;
  RemoveFromFavoriteSuccess({required this.removeFavoriteModel});
}
class RemoveFromFavoriteFailed extends AppartmentDetailsState{}
class CreateChatLoading extends AppartmentDetailsState{}
class CreateChatSuccess extends AppartmentDetailsState{
  final CreateChatSuccessful createChatSuccessful;
  CreateChatSuccess({required this.createChatSuccessful});
}
class CreateChatFailed extends AppartmentDetailsState{}
class AppartmentDetailsPageChanged extends AppartmentDetailsState {
  final int currentPage;
  
  AppartmentDetailsPageChanged({required this.currentPage});
}
class FavoriteStatusChanged extends AppartmentDetailsState {
  Iterable<Datum> isAlreadyFavorite;

  FavoriteStatusChanged({required this.isAlreadyFavorite});
}
class ChatStatusChanged extends AppartmentDetailsState {
  Iterable<ChatModel.Datum> hasAlreadyChats;

  ChatStatusChanged({required this.hasAlreadyChats});
}