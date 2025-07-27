import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/loading_dialog.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/favourit/repo/favourit_repo.dart';
import 'package:wow/features/block/repo/block_repo.dart';
import 'package:wow/features/home/bloc/home_user_bloc.dart';
import 'package:wow/features/interest/repo/interest_repo.dart';
import 'package:wow/features/plans/model/plans_model.dart';
import 'package:wow/features/plans/repo/plan_repo.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../main_models/custom_field_model.dart';
import '../../../navigation/routes.dart';
import '../../payment/bloc/payment_bloc.dart';

class PlanBloc extends HydratedBloc<AppEvent, AppState> {
  final PlanRepo repo;
  final InternetConnection internetConnection;

  PlanBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Get>(onGet);
    on<Add>(onAdd);
    on<Delete>(onDelete);
  }

  final nationality = BehaviorSubject<CustomFieldModel?>()
    ..add(CustomFieldModel());


  TextEditingController couponFeild= TextEditingController();
  Function(CustomFieldModel?) get updateNationality => nationality.sink.add;
  Stream<CustomFieldModel?> get nationalityStream =>
      nationality.stream.asBroadcastStream();

  BehaviorSubject<PlanData> selectedPlan = BehaviorSubject();
  Function(PlanData) get updateSelectedPlan => selectedPlan.sink.add;
  Stream<PlanData> get selectedPlanStream =>
      selectedPlan.stream.asBroadcastStream();

  PlansModel? plans;

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());

        Either<ServerFailure, Response> response = await repo.getPlans();

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          plans = PlansModel.fromJson(success.data);

          if (plans?.data?.isNotEmpty ?? false) {
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


        loadingDialog();
        Either<ServerFailure, Response> response = await repo.subscribe(
            event.arguments as int,
            coupon: couponFeild.text.trim(),
            nationality: nationality.valueOrNull?.id);
        response.fold((fail) {
          CustomNavigator.pop();

          AppCore.showSnackBar(
              notification: AppNotification(
            message: fail.error,
            isFloating: true,
            backgroundColor: Styles.IN_ACTIVE,
            borderColor: Styles.RED_COLOR,
          ));
        }, (success) {

          sl.get<PaymentBloc>().payRequestNowReadyUI(checkoutId: success.data['data']["checkout_id"]);
          // CustomNavigator.push(Routes.payment,arguments:success.data['data']["checkout_id"]);

          // AppCore.showSnackBar(
          //     notification: AppNotification(
          //   message: getTranslated("subscription_success"),
          //   isFloating: true,
          //   backgroundColor: Styles.ACTIVE,
          //   borderColor: Styles.ACTIVE,
          // ));
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
          sl<HomeUserBloc>().add(Click());
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
