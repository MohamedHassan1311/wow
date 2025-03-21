import 'dart:convert';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wow/features/categories/repo/categories_repo.dart';
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

class CategoriesBloc extends HydratedBloc<AppEvent, AppState> {
  final CategoriesRepo repo;
  final InternetConnection internetConnection;

  CategoriesBloc({required this.internetConnection, required this.repo})
      : super(Start()) {
    on<Click>(onClick);
  }

  final List<GlobalKey> globalKeys = [];

  animatedRowScroll(selectIndex) {
    Scrollable.ensureVisible(
        globalKeys[selectIndex].currentContext ??
            CustomNavigator.navigatorState.currentContext!,
        curve: Curves.ease,
        duration: const Duration(seconds: 1),
        alignment: 0.5);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response =
            await repo.getCategories(event.arguments as Map<String, dynamic>?);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Start());
          // emit(Error());
        }, (success) {
          if (success.data != null && success.data["data"] != null) {
            List<CategoryModel> list = List<CategoryModel>.from(
              (success.data["data"]).map(
                (v) => CategoryModel.fromJson(
                  v,
                  vendorId: (event.arguments as Map<String, dynamic>?)?["vendor_id"],
                  isVendor: (event.arguments as Map<String, dynamic>?)?["is_vendor"],
                ),
              ),
            );
            emit(Done(list: list));
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
        emit(Start());
        // emit(Error());
      }
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
