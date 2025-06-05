import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class BlockRepo extends BaseRepo {
  BlockRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getBlockedUsers() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.getBlockedUsers(userId));
      if (response.statusCode == 200) {





        
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
Future<Either<ServerFailure, Response>>   addtoBlock(id,reason) async {
   try {
      Response response = await dioClient.post(uri: EndPoints.block,data: {
        "blocked_by": userId,
        "blocked_id": id,
        "comment": reason,
      });
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

Future<Either<ServerFailure, Response>>   unblock(id) async {
   try {
      Response response = await dioClient.post(uri: EndPoints.unblock,data: {
        "blocked_by": userId,
        "blocked_id": id,
      });
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
