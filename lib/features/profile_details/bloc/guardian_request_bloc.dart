import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wow/components/loading_dialog.dart';
import 'package:wow/features/profile_details/repo/profile_details_repo.dart';
import 'package:wow/main_models/user_model.dart' show UserModel;
import 'package:wow/navigation/custom_navigation.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../app/core/app_core.dart';
import '../../../../../app/core/app_event.dart';
import '../../../../../app/core/app_notification.dart';
import '../../../../../app/core/app_state.dart';
import '../../../../../app/core/styles.dart';
import '../../../../../data/error/failures.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../navigation/routes.dart';
import '../../payment/bloc/payment_bloc.dart';
import '../model/categories_model.dart';

class GuardianRequestBloc extends HydratedBloc<AppEvent, AppState> {
  final ProfileDetailsRepo repo;

  GuardianRequestBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      loadingDialog();
      Either<ServerFailure, Response> response = await repo
          .guardianRequest({"target_client_id": event.arguments as int});

      response.fold((fail) {
        CustomNavigator.pop();
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        //
        sl.get<PaymentBloc>().payRequestNowReadyUI(
            checkoutlink: success.data['data']["checkout_link"]);
      });
    } catch (e) {
      AppCore.showSnackBar(
          notification: AppNotification(
        message: e.toString(),
        backgroundColor: Styles.IN_ACTIVE,
        borderColor: Styles.RED_COLOR,
      ));
      emit(Error());
    }
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['state'] == "Start") {
        return Start();
      }
      if (json['state'] == "Error") {
        return Error();
      }
      if (json['state'] == "Loading") {
        return Loading();
      }
      if (json['state'] == "Done") {
        return Done(
          list: List<CategoryModel>.from(
              jsonDecode(json['list']).map((e) => CategoryModel.fromJson(e))),
          loading: jsonDecode(json['loading']) as bool,
        );
      }
      return Loading();
    } catch (e) {
      return Error();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState? state) => state?.toJson();
}
