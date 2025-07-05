import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';
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
import '../../../data/internet_connection/internet_connection.dart';
import '../model/categories_model.dart';

class ProfileDetailsBloc extends Bloc<AppEvent, AppState> {
  final ProfileDetailsRepo repo;
  final InternetConnection internetConnection;

  ProfileDetailsBloc({required this.internetConnection, required this.repo})
      : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response =
            await repo.getProfileDetails(event.arguments as int);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          if (success.data != null && success.data["data"] != null) {
            UserModel user = UserModel.fromJson(success.data["data"]);

            emit(Done(data: user));
          } else {
            emit(Empty());
          }
        });
      } catch (e) {
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
        // emit(Start(≥));
        emit(Error());
      }
    }
  }
}
