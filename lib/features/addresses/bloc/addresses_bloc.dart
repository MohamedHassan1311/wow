import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/addresses/repo/addresses_repo.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../main_models/search_engine.dart';
import '../model/addresses_model.dart';

class AddressesBloc extends HydratedBloc<AppEvent, AppState> {
  final AddressesRepo repo;
  final InternetConnection internetConnection;

  AddressesBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
    on<Delete>(onDelete);
  }

  late ScrollController controller;

  late SearchEngine _engine;
  List<AddressModel>? _model;

  customScroll(ScrollController controller) {
    controller.addListener(() {
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage!);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage!);
        add(Click(arguments: _engine));
      }
    });
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        _engine = event.arguments as SearchEngine;
        if (_engine.currentPage == 0) {
          _model = [];
          if (!_engine.isUpdate) {
            emit(Loading());
          }
        } else {
          emit(Done(list: _model, loading: true));
        }

        Either<ServerFailure, Response> response =
            await repo.getAddresses(_engine);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          AddressesModel? model = AddressesModel.fromJson(success.data);

          if (_engine.currentPage == 0) {
            _model?.clear();
          }

          if (model.data != null && model.data!.isNotEmpty) {
            for (var address in model.data!) {
              _model?.removeWhere((e) => e.id == address.id);
              _model?.add(address);
            }
            _engine.maxPages = model.meta?.pagesCount ?? 1;
            _engine.updateCurrentPage(model.meta?.currentPage ?? 1);
          }

          if (_model != null && _model!.isNotEmpty) {
            emit(Done(list: _model, loading: false));
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

  ///Update Cards When Delete a card
  Future<void> onDelete(Delete event, Emitter<AppState> emit) async {
    _model?.removeWhere((e) => e.id == event.arguments as int);
    if (_model != null && _model!.isNotEmpty) {
      emit(Done(list: _model));
    } else {
      emit(Empty());
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
          list: List<AddressModel>.from(
              jsonDecode(json['list']).map((e) => AddressModel.fromJson(e))),
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
