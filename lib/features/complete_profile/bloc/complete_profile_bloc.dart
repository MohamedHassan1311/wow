import 'dart:convert';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/app/core/extensions.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';

import '../../../main_models/custom_field_model.dart';
import '../enitity/complete_profile_entity.dart';
import '../repo/complete_profile_repo.dart';

class CompleteProfileBloc extends Bloc<AppEvent, AppState> {
  final CompleteProfileRepo repo;
  CompleteProfileBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    updateCurrentStep(1);
  }

  final TextEditingController fName = TextEditingController();
  final TextEditingController lName = TextEditingController();
  final TextEditingController nickname = TextEditingController();
  final TextEditingController numberOfChildren = TextEditingController();
  final TextEditingController gfName = TextEditingController();
  final TextEditingController glName = TextEditingController();
  final TextEditingController gPhoneNumber = TextEditingController();
  final TextEditingController otherGuardian = TextEditingController();




  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();


  final nationality = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateNationality => nationality.sink.add;
  Stream<CustomFieldModel?> get nationalityStream =>
      nationality.stream.asBroadcastStream();

  final otherNationality = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateOtherNationality => otherNationality.sink.add;
  Stream<CustomFieldModel?> get otherNationalityStream =>
      otherNationality.stream.asBroadcastStream();

  final countryOfResidence = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateCountryOfResidence=> countryOfResidence.sink.add;
  Stream<CustomFieldModel?> get countryOfResidenceStream =>
      countryOfResidence.stream.asBroadcastStream();

  final city = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateCity=> city.sink.add;
  Stream<CustomFieldModel?> get cityStream =>
      city.stream.asBroadcastStream();



  final socialStatus = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateSocialStatus=> socialStatus.sink.add;
  Stream<CustomFieldModel?> get socialStatusStream =>
      socialStatus.stream.asBroadcastStream();

  final gender = BehaviorSubject<int?>();
  Function(int?) get updateGender => gender.sink.add;
  Stream<int?> get genderStream => gender.stream.asBroadcastStream();

  final grelation = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateGrelation => grelation.sink.add;
  Stream<CustomFieldModel?> get GrelationStream => grelation.stream.asBroadcastStream();


  final dop = BehaviorSubject<DateTime?>();
  Function(DateTime?) get updateDOP=> dop.sink.add;
  Stream<DateTime?> get dopStream => dop.stream.asBroadcastStream();

  final registerEntity = BehaviorSubject<CompleteProfileEntity?>();
  Function(CompleteProfileEntity?) get updateRegisterEntity =>
      registerEntity.sink.add;
  Stream<CompleteProfileEntity?> get registerEntityStream =>
      registerEntity.stream.asBroadcastStream();

  final phoneCode = BehaviorSubject<String?>();
  Function(String?) get updatePhoneCode => phoneCode.sink.add;
  Stream<String?> get phoneCodeStream => phoneCode.stream.asBroadcastStream();

  final currentStep = BehaviorSubject<int?>();
  Function(int?) get updateCurrentStep => currentStep.sink.add;
  Stream<int?> get currentStepStream => currentStep.stream.asBroadcastStream();
  PageController pageController =PageController(initialPage: 0);
  String stepTitle(step) {

      if (step == 1) {
        return "Name_and_gender";
      }
      if (step == 2) {
        return "Nationality_and_country";
      }
      if (step == 3) {
        return "Marital status";
      }  if (step == 4) {
        return "Guardian's data";
      }
else return "";

  }

  clear() {

    // updateProfileImage(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      var data = json.encode({
        "fname": fName.text.trim(),
        "lname": lName.text.trim(),
        "email": "ahmeedhassanali@outlook.com",
        "phone": "123456789",
        "country_id":nationality.valueOrNull?.id,
        "city_id": city.valueOrNull?.id,
        "dob": dop.valueOrNull!.defaultFormat2(),
        "social_status": socialStatus.valueOrNull?.id,
        "gender": gender.valueOrNull,
        "nickname":nickname.text.trim(),
        "gfname": gfName.text.trim(),
        "glname": lName.text.trim(),
        "gphone": gPhoneNumber.text.trim(),
        "grelation": grelation.valueOrNull?.id,
        "grelation_other": otherGuardian.text.trim(),
        "num_of_sons": numberOfChildren.text.trim(),
        "nationality_id": nationality.valueOrNull?.id,
        "other_nationality_id": otherNationality.valueOrNull?.id,
        // "education": "test",
        // "education_2": "test",
        //
        // "job_title": "test",
        // "salary": "10000",
        // "height": 170,
        // "weight": 90,
        // "body_type": 2,
        // "complexion": 1,
        // "tribe": 1,
        // "religion": 1,
        // "about_me": "sssssssss",
        //
        // "identity_file": "dd"
      });
      print(data);
      Either<ServerFailure, Response> response =
          await repo.completeProfile(registerEntity.valueOrNull?.toJson());

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

        // CustomNavigator.push(Routes.verification,
        //     arguments: VerificationModel(
        //         email: registerEntity.valueOrNull?.email?.text.trim(),
        //         phone: registerEntity.valueOrNull?.phone?.text.trim(),
        //         countryCode: registerEntity.valueOrNull?.country?.code,
        //         fromRegister: true));
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
