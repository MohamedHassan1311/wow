import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/app/localization/language_constant.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../repo/marriage_conditions_repo.dart';

class MarriageConditionsBloc extends Bloc<AppEvent, AppState> {
  final MarriageConditionsRepo repo;
  final InternetConnection internetConnection;

  MarriageConditionsBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Add>(onAdd);
  }

  final marriageConditions = BehaviorSubject<List<int>?>();
  Function(List<int>?) get updateMarriageConditions => marriageConditions.sink.add;
  Stream<List<int>?> get marriageConditionsStream =>
      marriageConditions.stream.asBroadcastStream();

  TextEditingController marriageConditionsController = TextEditingController();

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        if(!marriageConditions.hasValue){
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: getTranslated("choose_marriage_conditions"),
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          return;
        }
        emit(Loading());

  var data = FormData.fromMap({
       "marriage_condition[]": marriageConditions.valueOrNull,
    if(marriageConditionsController.text.isNotEmpty)
       "other_condition": marriageConditionsController.text.isNotEmpty?marriageConditionsController.text:"",

      });
        Either<ServerFailure, Response> response =
            await repo.postMarriageConditions(data);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {

             AppCore.showSnackBar(
              notification: AppNotification(
                  message: getTranslated("condition_add_done",),
                  isFloating: true,
                  backgroundColor: Styles.ACTIVE,
                  borderColor: Colors.green));
          if (success.data['data'] != null) {
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




}
