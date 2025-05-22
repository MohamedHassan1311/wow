import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_models/search_engine.dart';
import '../../../../data/api/end_points.dart';
import '../../../../data/error/api_error_handler.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_repos/base_repo.dart';

class FillterRepo extends BaseRepo {
  FillterRepo({required super.sharedPreferences, required super.dioClient});

  Future<Either<ServerFailure, Response>> submitFilter(SearchEngine searchEngine, data) async {
    try {
      Response response = await dioClient.post(

          uri:EndPoints.submitFilter,
          queryParameters: {
            "page": searchEngine.currentPage!+1,
          },
          
           data: data,);

      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      print(error);
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
