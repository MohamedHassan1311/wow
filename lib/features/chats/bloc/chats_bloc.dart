import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../main_models/search_engine.dart';
import '../model/chats_model.dart';
import '../repo/chats_repo.dart';
import '../widgets/chat_card.dart';

class ChatsBloc extends HydratedBloc<AppEvent, AppState> {
  final ChatsRepo repo;
  final InternetConnection internetConnection;

  ChatsBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    controller = ScrollController();
    customScroll(controller);
    on<Click>(onClick);
    on<Delete>(onDelete);
  }

  late ScrollController controller;

  late SearchEngine _engine;
  List<Widget>? _cards;

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
          _cards = [];
          if (!_engine.isUpdate) {
            emit(Loading());
          }
        } else {
          emit(Done(cards: _cards, loading: true));
        }

        Either<ServerFailure, Response> response = await repo.getChats(_engine);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          ChatsModel? model = ChatsModel.fromJson(success.data);

          if (_engine.currentPage == 0) {
            _cards?.clear();
          }

          if (model.data != null && model.data!.isNotEmpty) {
            for (var chat in model.data!) {
              _cards?.removeWhere((e) =>
                  (e.key as ValueKey<int?>).value == ValueKey(chat.id).value);
              _cards?.add(ChatCard(key: ValueKey(chat.id), chat: chat));
            }
            _engine.maxPages = model.meta?.pagesCount ?? 1;
            _engine.updateCurrentPage(model.meta?.currentPage ?? 1);
          }

          if (_cards != null && _cards!.isNotEmpty) {
            emit(Done(cards: _cards, loading: false));
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
    _cards?.removeWhere((e) =>
        (e.key as ValueKey<int?>).value ==
        ValueKey(event.arguments as int).value);
    if (_cards != null && _cards!.isNotEmpty) {
      emit(Done(cards: _cards));
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
          list: List<ChatModel>.from(
              jsonDecode(json['list']).map((e) => ChatModel.fromJson(e))),
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
