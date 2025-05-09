import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class CompleteProfileRepo extends BaseRepo {
  CompleteProfileRepo({required super.sharedPreferences, required super.dioClient});

  Future<Either<ServerFailure, Response>> completeProfile(data,{required bool isEdit}) async {
    try {
      print(isEdit);
      Response response = await dioClient.post(
          uri:isEdit? EndPoints.editProfile(userId):EndPoints.storeProfile(userId), data: data);

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }  Future<Either<ServerFailure, Response>> getSettingOptions(fillter) async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.optionsSettings, queryParameters:fillter );

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
}
