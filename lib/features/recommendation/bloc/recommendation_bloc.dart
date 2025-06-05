import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/features/recommendation/repo/recommendation_repo.dart';
import 'package:wow/main_models/meta.dart';
import 'package:wow/main_models/search_engine.dart';
import 'package:wow/main_models/user_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';

class RecommendationBloc extends HydratedBloc<AppEvent, AppState> {
  final RecommendationRepo repo;
  final InternetConnection internetConnection;

  RecommendationBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Get>(onGet);
      controller = ScrollController();
    customScroll(controller);
  }

  late ScrollController controller;
  late SearchEngine _engine;

  customScroll(ScrollController controller) {
    controller.addListener(() {
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage!);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage!);
        add(Get(arguments: _engine));
      }
    });
  }
  List<UserModel>? recommendations;
  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {

      _engine = event.arguments as SearchEngine;
      if (_engine.currentPage == 0) {
        recommendations = [];
        if (!_engine.isUpdate) {
          emit(Loading());
        }
      } else {
        emit(Done( loading: true));
      }
        emit(Loading());
        recommendations = [];
        Either<ServerFailure, Response> response =
            await repo.getRecommendation(_engine);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {


        Meta meta = Meta.fromJson(success.data['meta']);
        if (_engine.currentPage == 0) {
          recommendations!.clear();
        }

      
          if (success.data['data'].isNotEmpty) {
          var  res =
                success.data['data'].map((e) => UserModel.fromJson(e)).toList();
                  if (res.isNotEmpty) {
          for (var item in res) {
            recommendations!.removeWhere((e) => e.id == item.id);
            recommendations!.add(item);
          }
          _engine.maxPages = meta.pagesCount ?? 1;
          _engine.updateCurrentPage(meta.currentPage ?? 1);
        }
          }

          if (recommendations!.isNotEmpty) {
            emit(Done(data: recommendations));
          } else {
            emit(Empty());
          }
        });
      } catch (e) {
        print(e);
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
