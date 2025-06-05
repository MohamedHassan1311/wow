import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../../../main_models/search_engine.dart';
import '../../../main_repos/base_repo.dart';
import '../model/subscription_model.dart';

class SubscriptionRepo extends BaseRepo {
  SubscriptionRepo(
      {required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getSubscriptions(
      SearchEngine data) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.subscriptions(userId),
        queryParameters: {
          "page": data.currentPage! + 1,
          "limit": data.limit,
        },
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

  Future<Either<ServerFailure, Response>> cancelSubscription(String subscriptionId) async {
    try {
      Response response = await dioClient.post(
        uri: EndPoints.cancelSubscription,
        data: {"subscription_id": subscriptionId},
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