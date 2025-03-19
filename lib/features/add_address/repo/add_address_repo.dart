import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:wow/main_repos/base_repo.dart';
import '../../../data/api/end_points.dart';
import '../../../data/error/api_error_handler.dart';
import '../../../data/error/failures.dart';
import '../entity/add_address_entity.dart';

class AddAddressRepo extends BaseRepo {
  AddAddressRepo({required super.dioClient, required super.sharedPreferences});

  Future<Either<ServerFailure, Response>> addAddress(
      AddressEntity data) async {
    try {
      Response response = await dioClient.post(
        uri: data.id != null
            ? EndPoints.editAddress(data.id)
            : EndPoints.addAddress,
        data: FormData.fromMap(data.toJson()),
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
