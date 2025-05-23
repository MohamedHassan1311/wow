import 'package:wow/features/auth/reset_password/entity/reset_password_entity.dart';
import 'package:wow/features/auth/verification/model/verification_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../repo/reset_password_repo.dart';

class ResetPasswordBloc extends Bloc<AppEvent, AppState> {
  final ResetPasswordRepo repo;
  ResetPasswordBloc({required this.repo}) : super(Start()) {
    on<Click>(_resetPassword);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  final resetPasswordEntity = BehaviorSubject<ResetPasswordEntity?>();
  Function(ResetPasswordEntity?) get updateResetPasswordEntity => resetPasswordEntity.sink.add;
  Stream<ResetPasswordEntity?> get resetPasswordEntityStream => resetPasswordEntity.stream.asBroadcastStream();

  bool isBodyValid() {
    for (var entry
        in (resetPasswordEntity.valueOrNull?.toJson() ?? {}).entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  clear() {
    updateResetPasswordEntity(null);
  }

  _resetPassword(AppEvent event, Emitter emit) async {
    if (isBodyValid()) {
      try {
        emit(Loading());
        Map<String, dynamic> data =
            (event.arguments as VerificationModel).toJson();

        data.addAll(resetPasswordEntity.valueOrNull!.toJson());

        Either<ServerFailure, Response> response =
            await repo.resetPassword(data);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          CustomNavigator.push(Routes.login, clean: true);
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: getTranslated("your_password_reset_successfully"),
                  backgroundColor: Styles.ACTIVE,
                  borderColor: Styles.ACTIVE,
                  isFloating: true));
          clear();
          emit(Done());
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
}
