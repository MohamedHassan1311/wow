import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/favourit/repo/favourit_repo.dart';
import 'package:wow/features/block/repo/block_repo.dart';
import 'package:wow/features/home/bloc/home_user_bloc.dart';
import 'package:wow/features/interest/repo/interest_repo.dart';
import 'package:wow/main_models/custom_field_model.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';

class BlockBloc extends HydratedBloc<AppEvent, AppState> {
  final BlockRepo repo;
  final InternetConnection internetConnection;

  BlockBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    emit(Start());
    on<Get>(onGet);
    on<Add>(onAdd);
    on<Delete>(onDelete);
  }

  TextEditingController blockReasonController = TextEditingController();

  BehaviorSubject<CustomFieldModel> blockReason = BehaviorSubject();
  Function(CustomFieldModel) get updateBlockReason => blockReason.sink.add;
  Stream<CustomFieldModel> get blockReasonStream =>
      blockReason.stream.asBroadcastStream();

  List<UserModel> users = [];

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());
        users = [];
        Either<ServerFailure, Response> response = await repo.getBlockedUsers();

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          users = List<UserModel>.from(
              success.data['data'].map((e) => UserModel.fromJson(e)));

          if (users.isNotEmpty) {
            emit(Done());
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
        emit(Error());
      }
    }
  }

  onAdd(Add event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response = await repo.addtoBlock(
            event.arguments as int, blockReasonController.text);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
            message: fail.error,
            isFloating: true,
            backgroundColor: Styles.IN_ACTIVE,
            borderColor: Styles.RED_COLOR,
          ));
          emit(Error());
        }, (success) {
          AppCore.showSnackBar(
              notification: AppNotification(
            message: success.data['message'],
            isFloating: true,
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.ACTIVE,
          ));
          CustomNavigator.push(Routes.dashboard, clean: true);
          emit(Done());
        });
      } catch (e) {
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
      }
    }
  }

  onDelete(Delete event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response =
            await repo.unblock(event.arguments as int);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
            message: fail.error,
            isFloating: true,
            backgroundColor: Styles.IN_ACTIVE,
            borderColor: Styles.RED_COLOR,
          ));
          emit(Error());
        }, (success) {
          users.removeWhere((element) => element.id == event.arguments);
          AppCore.showSnackBar(
              notification: AppNotification(
            message: success.data['message'],
            isFloating: true,
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.ACTIVE,
          ));
          emit(Done());
        });
      } catch (e) {
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
      }
    }
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) {
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
