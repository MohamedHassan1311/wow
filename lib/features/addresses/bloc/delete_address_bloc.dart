import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/loading_dialog.dart';
import 'package:wow/features/addresses/repo/addresses_repo.dart';
import 'package:wow/navigation/custom_navigation.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';

class DeleteAddressBloc extends Bloc<AppEvent, AppState> {
  final AddressesRepo repo;

  DeleteAddressBloc({required this.repo}) : super(Start()) {
    on<Delete>(onDelete);
  }

  Future<void> onDelete(Delete event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();
      Either<ServerFailure, Response> response = await repo
          .deleteAddress((event.arguments as Map<String, dynamic>)["id"]);
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        (event.arguments as Map<String, dynamic>)["onSuccess"].call();
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("the_chat_has_been_deleted_successfully"),
          backgroundColor: Styles.ACTIVE,
          borderColor: Styles.ACTIVE,
        ));
        emit(Done());
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }
}
