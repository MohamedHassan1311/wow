import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_models/search_engine.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class ChatsRepo extends BaseRepo {
  ChatsRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getChats(SearchEngine data) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.chatSMessages(userId),

      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
  Future<Either<ServerFailure, Response>> startChat( {required int doctor_id }) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.startNewChat(userId),
        data: {
          "user_id": doctor_id
        },
      );
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> deleteChat(id) async {
    try {
      Response response = await dioClient.delete(
        uri: EndPoints.deleteChat(id),
      );
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
