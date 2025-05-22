import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/main_models/user_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../model/ads_model.dart';
import '../repo/home_repo.dart';

class HomeUserBloc extends HydratedBloc<AppEvent, AppState> {
  final HomeRepo repo;
  final InternetConnection internetConnection;

  HomeUserBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Click>(onClick);
  }



 UserModel? model;
  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      // try {
        emit(Loading());

        Either<ServerFailure, Response> response = await repo.getHomeUser();

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
           model = UserModel.fromJson(success.data['data']);
          if (model != null ) {
            emit(Done());
          } else {
            emit(Empty());
          }
        });
      // } catch (e) {
      //   print(e);
      //   AppCore.showSnackBar(
      //       notification: AppNotification(
      //     message: e.toString(),
      //     backgroundColor: Styles.IN_ACTIVE,
      //     borderColor: Styles.RED_COLOR,
      //   ));
      //   emit(Error());
      // }
    }
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
    print(json);
    try {
      if (json['state'] == "Start") {
        return Loading();
      }
      if (json['state'] == "Error") {
        return Error();
      }
      if (json['state'] == "Loading") {
        return Loading();
      }
      if (json['state'] == "Done") {
        return Done(
          model: UserModel.fromJson(jsonDecode(json['data'])),
          loading: jsonDecode(json['loading']) as bool,
        );
      }
      return Start();
    } catch (e) {
      return Error();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState? state) => state?.toJson();
}
