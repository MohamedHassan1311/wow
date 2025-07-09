import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../data/api/end_points.dart';
import '../../../../../data/error/api_error_handler.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_repos/base_repo.dart';

class ProfileDetailsRepo extends BaseRepo {
  ProfileDetailsRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getProfileDetails(
      int id) async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.profile(id),
          );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }  Future<Either<ServerFailure, Response>> guardianRequest(
      data
 ) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.guardianRequest(userId),
        data: data
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
