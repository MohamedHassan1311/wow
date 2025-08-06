import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class MarigeRequestRepo extends BaseRepo {
  MarigeRequestRepo(
      {required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getMarigeRequest() async {
    try {
      print("user gender ${UserBloc.instance.user?.gender.toString()}");
      Response response = await dioClient.get(
          uri: UserBloc.instance.user?.gender == "F"
              ? EndPoints.getmarigeRequestReceived(
                  userId)
              : EndPoints.getmarigeRequestSend(
                  userId));
      if (response.statusCode == 200) {
        return Right(response);
      } else {
        return left(ApiErrorHandler.getServerFailure(response.data['message']));
      }
    } catch (error) {
      return left(ApiErrorHandler.getServerFailure(error));
    }
  }

  Future<Either<ServerFailure, Response>> sendMarigeRequest(int id, message) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.sendMarigeRequest,
          data: {
            "sender_id": userId,
            "receiver_id": id,
            "message": "$message"
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
    Future<Either<ServerFailure, Response>> acceptMarigeRequest(int id) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.acceptMarigeRequest(id),
          data: {
            "id": id,
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

 Future<Either<ServerFailure, Response>> rejectMarigeRequest(int id,cancelReason) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.rejectMarigeRequest(id),
          data: {
            "id": id,
            "cancel_reason":cancelReason
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
   Future<Either<ServerFailure, Response>> cancelMarigeRequest(int id,cancelReason) async {
    try {
      Response response = await dioClient.post(
          uri: EndPoints.cancelMarigeRequest(id),
          data: {
            "id": id,
            "cancel_reason":cancelReason

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
