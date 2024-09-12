import 'package:dartz/dartz.dart';
import 'package:homez/core/error/failures.dart';
import 'package:homez/core/networking/api_constants.dart';
import 'package:homez/core/networking/api_consumer.dart';
import 'package:homez/features/appartment_details/data/model/favorite_model.dart';
import 'package:homez/features/search/data/models/recent_search_model.dart';
import 'package:homez/features/search/data/models/search_result_model.dart';

class SearchRepo {
  ApiConsumer apiConsumer;
  SearchRepo({required this.apiConsumer});
  Future<Either<Failure, RecentSearchModel>> getRecentSearch() async {
    try {
      final response = await apiConsumer.get(ApiConstants.recentSearch);
      if (response.statusCode == 200) {
        return Right(RecentSearchModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, RecentSearchModel>> deleteRecentSearchById(
      {required int id}) async {
    try {
      final response = await apiConsumer
          .post(ApiConstants.deleteRecentSearchById + id.toString());
      if (response.statusCode == 200) {
        return Right(RecentSearchModel.fromJson(response.data));
      } else {
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if (e is ServerFailure) {
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }

  Future<Either<Failure, SearchResultModel>> defaultSearch(
      {required String keyword}) async {
    try {
      final response = await apiConsumer.get(ApiConstants.search,queryParameters: {
       
          "type":"rent",
          "search_string":keyword,  
    
      });
      if(response.statusCode == 200){
        return Right(SearchResultModel.fromJson(response.data));
      }else{
        return Left(ServerFailure(response.data));
      }
    } catch (e) {
      if(e is ServerFailure){
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
      }
    }
      Future<Either<Failure, FavoriteModel>> addToFavoirte({required int apartmentId}) async {
    try {
      final response = await apiConsumer.post('${ApiConstants.addOrRemoveFavoirte}$apartmentId');
      if(response.statusCode == 200){
       return Right(FavoriteModel.fromJson(response.data));
      }else{
      return Left(ServerFailure(response.data));
      }
      
    } catch (e) {
      if(e is ServerFailure){
        return Left(e);
      }
      return Left(ServerFailure('An unknown error: $e'));
    }
  }
  }

