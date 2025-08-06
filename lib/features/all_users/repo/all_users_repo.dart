import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_models/search_engine.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class AllUsersRepo extends BaseRepo {
  AllUsersRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getAllUsers(SearchEngine engine) async {
    try {
      Response response = await dioClient.get(uri: EndPoints.getAllUsers(userId),
      queryParameters: {
        "page": engine.currentPage!+1,
      }
      );
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
