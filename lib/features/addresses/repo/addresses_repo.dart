import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_models/search_engine.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';

class AddressesRepo extends BaseRepo {
  AddressesRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> getAddresses(
      SearchEngine data) async {
    try {
      Response response = await dioClient.get(
        uri: EndPoints.addresses,
        queryParameters: {"page": data.currentPage! + 1, "limit": data.limit},
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

  Future<Either<ServerFailure, Response>> deleteAddress(id) async {
    try {
      Response response = await dioClient.delete(
        uri: EndPoints.deleteAddress(id),
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
