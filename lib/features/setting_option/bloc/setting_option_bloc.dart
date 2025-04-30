import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../data/error/failures.dart';
import '../../../main_models/custom_field_model.dart';
import '../repo/setting_option_repo.dart';

class SettingOptionBloc extends Bloc<AppEvent, AppState> {
  final SettingOptionRepo repo;

  SettingOptionBloc({required this.repo}) : super(Start()) {
    on<Get>(onGet);
  }

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      Either<ServerFailure, Response> response =
          await repo.getSetting(event.arguments );

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        final model = CustomFieldsModel.fromJson(success.data);
        emit(Done(model: model));
      });
    } catch (e) {
      AppCore.showSnackBar(
        notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ),
      );
      emit(Error());
    }
  }
}
