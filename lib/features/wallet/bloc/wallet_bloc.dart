import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/features/transactions/model/transactions_model.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../main_models/search_engine.dart';
import '../model/wallet_model.dart';
import '../model/wallets_model.dart';
import '../repo/wallet_repo.dart';

class WalletBloc extends Bloc<AppEvent, AppState> {
  final WalletRepo repo;

  WalletBloc({required this.repo}) : super(Start()) {
    on<Click>(oClick);
  }

  late SearchEngine _engine;
ScrollController? controller;
  customScroll(ScrollController controller) {
    this.controller = controller;
    controller.addListener(() {
      bool scroll = AppCore.scrollListener(
          controller, _engine.maxPages, _engine.currentPage!);
      if (scroll) {
        _engine.updateCurrentPage(_engine.currentPage!);
        add(Click(arguments: _engine));
      }
    });
  }

  TransactionsModel? model;

  Future<void> oClick(Click event, Emitter<AppState> emit) async {
    try {
      _engine = event.arguments as SearchEngine;
      if (_engine.currentPage == 0) {
        model = null;
        if (!_engine.isUpdate) {
          emit(Loading());
        }
      } else {
        emit(Done( loading: true));
      }

      Either<ServerFailure, Response> response =
          await repo.getWallets(_engine);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        model = TransactionsModel.fromJson(success.data);

        // if (_engine.currentPage == 0) {
        //   model = null;
        // }

        // if (res.data != null && res.data!.isNotEmpty) {
        //   for (var wallet in res.data!) {
        //     model?.data?.removeWhere((e) => e.id == wallet.id);
        //     model?.data?.add(wallet);
        //   }

        //   _engine.maxPages = res.meta?.pagesCount ?? 1;
        //   _engine.updateCurrentPage(res.meta?.currentPage ?? 1);
        // }
        if (model?.data != null && model!.data!.isNotEmpty) {
          emit(Done(list: model!.data, loading: false));
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