import 'package:wow/app/localization/language_constant.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/loading_dialog.dart';
import 'package:wow/features/auth/deactivate_account/repo/deactivate_account_repo.dart';
import 'package:wow/navigation/custom_navigation.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_blocs/user_bloc.dart';
import '../../../../navigation/routes.dart';
import '../repo/destroy_account_repo.dart';

class DestroyAccountBloc extends Bloc<AppEvent, AppState> {
  final DestroyAccountRepo repo;

  DestroyAccountBloc({required this.repo}) : super(Start()) {
    on<Delete>(onDelete);
  }

  Future<void> onDelete(Delete event, Emitter<AppState> emit) async {
    try {
      loadingDialog();
      emit(Loading());
      Either<ServerFailure, Response> response = await repo.deactivateAccount();
      CustomNavigator.pop();

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        UserBloc.instance.add(Delete());
        CustomNavigator.push(Routes.splash, clean: true);
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("you_deactivate_your_account_successfully"),
          backgroundColor: Styles.ACTIVE,
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
        ),
      );
      emit(Error());
    }
  }
}
