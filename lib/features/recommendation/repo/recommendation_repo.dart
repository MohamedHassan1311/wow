import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class RecommendationRepo extends BaseRepo {
  RecommendationRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getFavourit() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.getFavouritSent(userId));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> addtoFavourit(id) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.addToFavourit,
          data: {"sender_id": userId, "receiver_id": id});
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
