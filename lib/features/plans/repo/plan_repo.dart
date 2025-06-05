import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class PlanRepo extends BaseRepo {
  PlanRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getPlans() async {
    try {
      Response response = await dioClient.get(uri: EndPoints.getPlans);
      if (response.statusCode == 200) {





        
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }
Future<Either<ServerFailure, Response>>   subscribe(id) async {
   try {
      Response response = await dioClient.post(uri: EndPoints.subscribe(userId),data: {
        "plan_id": id,

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
