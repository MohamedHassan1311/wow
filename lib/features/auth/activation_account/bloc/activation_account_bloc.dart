import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/loading_dialog.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../repo/activation_account_repo.dart';

class ActivationAccountBloc extends Bloc<AppEvent, AppState> {
  final ActivationAccountRepo repo;

  ActivationAccountBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();

      Either<ServerFailure, Response> response =
          await repo.activateAccount(event.arguments.toString() );
      CustomNavigator.pop();

      response.fold((fail) {
        CustomNavigator.pop();

        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));        emit(Error());
      }, (success) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: getTranslated('un_freeze_account'),
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Colors.transparent));
        CustomNavigator.pop();

        emit(Done());
      });
    } catch (e) {
      CustomNavigator.pop();
      AppCore.showToast(getTranslated("something_went_wrong"));
      emit(Error());
    }
  }
}
