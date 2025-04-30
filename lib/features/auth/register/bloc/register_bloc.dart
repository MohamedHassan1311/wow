import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_models/custom_field_model.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../verification/model/verification_model.dart';
import '../enitity/register_entity.dart';
import '../repo/register_repo.dart';

class RegisterBloc extends Bloc<AppEvent, AppState> {
  final RegisterRepo repo;
  RegisterBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    updateAgreeToTerms(null);
  }

  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode countryNode = FocusNode();
  final FocusNode passwordNode = FocusNode();
  final FocusNode confirmPasswordNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  // final profileImage = BehaviorSubject<File?>();
  // Function(File?) get updateProfileImage => profileImage.sink.add;
  // Stream<File?> get profileImageStream =>
  //     profileImage.stream.asBroadcastStream();

  final registerEntity = BehaviorSubject<RegisterEntity?>();
  Function(RegisterEntity?) get updateRegisterEntity => registerEntity.sink.add;
  Stream<RegisterEntity?> get registerEntityStream =>
      registerEntity.stream.asBroadcastStream();

  final phoneCode = BehaviorSubject<String?>();
  Function(String?) get updatePhoneCode => phoneCode.sink.add;
  Stream<String?> get phoneCodeStream => phoneCode.stream.asBroadcastStream();

  final agreeToTerms = BehaviorSubject<bool?>();
  Function(bool?) get updateAgreeToTerms => agreeToTerms.sink.add;
  Stream<bool?> get agreeToTermsStream =>
      agreeToTerms.stream.asBroadcastStream();

  clear() {
    updateRegisterEntity(RegisterEntity(
      name: TextEditingController(),
      email: TextEditingController(),
      phone: TextEditingController(),
      country:"+966" ,
      password: TextEditingController(),
      confirmPassword: TextEditingController(),
    ));
    updateAgreeToTerms(null);
    // updateProfileImage(null);
  }
  bool isBodyValid() {
    log("==>Body${registerEntity.valueOrNull?.toJson()}");
    for (var entry in (registerEntity.valueOrNull?.toJson())!.entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      CustomNavigator.push(Routes.CompleteProfile,
     );
      if(isBodyValid()==false)
      {
        return;
      }
      if (agreeToTerms.valueOrNull != true) {
        return AppCore.showToast(
          getTranslated("oops_you_must_agree_to_terms_and_conditions"),
        );
      }



      emit(Loading());
      print(phoneCode);

      Either<ServerFailure, Response> response =
          await repo.register(registerEntity.valueOrNull?.toJson());

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        AppCore.showSnackBar(
          notification: AppNotification(
            message: getTranslated("register_success_description"),
            backgroundColor: Styles.ACTIVE,
            borderColor: Styles.ACTIVE,
          ),
        );

        CustomNavigator.push(Routes.verification,
            arguments: VerificationModel(
                email: registerEntity.valueOrNull?.email?.text.trim(),
                phone: registerEntity.valueOrNull?.phone?.text.trim(),
                countryCode: registerEntity.valueOrNull?.country,
                fromRegister: true));
        clear();
        emit(Done());
      });
    } catch (e) {
      AppCore.showSnackBar(
        notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ),
      );
      emit(Error());
    }
  }
}
