import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../data/api/end_points.dart';
import '../../../../../data/error/api_error_handler.dart';
import '../../../../../data/error/failures.dart';
import '../../../../../main_repos/base_repo.dart';
import '../../../data/config/di.dart';

class CheckOutRepo extends BaseRepo {
  CheckOutRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> checkStatus({checkOutID}) async {
    try {
      Response response = await dioClient.get(
          uri: EndPoints.checkPayment(checkOutID),
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
