import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../data/error/failures.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/styles.dart';
import '../enitity/contact_with_us_entity.dart';
import '../repo/contact_with_us_repo.dart';

class ContactWithUsBloc extends Bloc<AppEvent, AppState> {
  final ContactWithUsRepo repo;

  ContactWithUsBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode countryNode = FocusNode();
  final FocusNode messageNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  final entity = BehaviorSubject<ContactWithUsEntity?>();
  Function(ContactWithUsEntity?) get updateEntity => entity.sink.add;
  Stream<ContactWithUsEntity?> get entityStream =>
      entity.stream.asBroadcastStream();

  bool isBodyValid() {
    log("==>Body${entity.valueOrNull?.toJson()}");
    for (var entry in (entity.valueOrNull?.toJson())!.entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  clear() {
    updateEntity(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response =
          await repo.contactUs(entity.valueOrNull?.toJson());

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        clear();
        CustomNavigator.pop();
        AppCore.showSnackBar(
            notification: AppNotification(
                message:
                    getTranslated("your_problem_has_been_sent_successfully"),
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Styles.ACTIVE));
        emit(Done());
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
