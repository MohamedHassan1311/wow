import 'dart:convert';
import 'dart:developer';
import 'dart:io';

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

import '../../../app/core/dimensions.dart';
import '../../../components/custom_alert_dialog.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_models/custom_field_model.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../enitity/complete_profile_entity.dart';
import '../repo/complete_profile_repo.dart';
import '../widget/submit_success_dialog.dart';

class CompleteProfileBloc extends Bloc<AppEvent, AppState> {
  final CompleteProfileRepo repo;
  CompleteProfileBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    updateCurrentStep(1);
    updateDOP(DateTime(1999));
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
  final formKey5 = GlobalKey<FormState>();

  final nationality = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());

  Function(CustomFieldModel?) get updateNationality => nationality.sink.add;
  Stream<CustomFieldModel?> get nationalityStream =>
      nationality.stream.asBroadcastStream();

  final otherNationality = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateOtherNationality =>
      otherNationality.sink.add;
  Stream<CustomFieldModel?> get otherNationalityStream =>
      otherNationality.stream.asBroadcastStream();

  final countryOfResidence = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCountryOfResidence =>
      countryOfResidence.sink.add;
  Stream<CustomFieldModel?> get countryOfResidenceStream =>
      countryOfResidence.stream.asBroadcastStream();

  final city = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCity => city.sink.add;
  Stream<CustomFieldModel?> get cityStream => city.stream.asBroadcastStream();

  final socialStatus = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateSocialStatus => socialStatus.sink.add;
  Stream<CustomFieldModel?> get socialStatusStream =>
      socialStatus.stream.asBroadcastStream();

  final gender = BehaviorSubject<int?>()..add(1);
  Function(int?) get updateGender => gender.sink.add;
  Stream<int?> get genderStream => gender.stream.asBroadcastStream();

  final grelation = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateGrelation => grelation.sink.add;
  Stream<CustomFieldModel?> get GrelationStream =>
      grelation.stream.asBroadcastStream();

  final dop = BehaviorSubject<DateTime?>();
  Function(DateTime?) get updateDOP => dop.sink.add;
  Stream<DateTime?> get dopStream => dop.stream.asBroadcastStream();

  final registerEntity = BehaviorSubject<CompleteProfileEntity?>();
  Function(CompleteProfileEntity?) get updateRegisterEntity =>
      registerEntity.sink.add;
  Stream<CompleteProfileEntity?> get registerEntityStream =>
      registerEntity.stream.asBroadcastStream();

  final phoneCode = BehaviorSubject<String?>();
  Function(String?) get updatePhoneCode => phoneCode.sink.add;
  Stream<String?> get phoneCodeStream => phoneCode.stream.asBroadcastStream();

  final identityImage = BehaviorSubject<File?>();
  Function(File?) get updateIdentityImage => identityImage.sink.add;
  Stream<File?> get identityImageeStream =>
      identityImage.stream.asBroadcastStream();

  final currentStep = BehaviorSubject<int?>();
  Function(int?) get updateCurrentStep => currentStep.sink.add;
  Stream<int?> get currentStepStream => currentStep.stream.asBroadcastStream();
  PageController pageController = PageController(initialPage: 0);
  String stepTitle(step) {
    if (step == 1) {
      return "Name_and_gender";
    }
    if (step == 2) {
      return "Nationality_and_country";
    }
    if (step == 3) {
      return "Marital status";
    }
    if (step == 4) {
      return "Guardian's data";
    }
    if (step == 5) {
      return "verification";
    } else
      return "";
  }

  clear() {
    // updateProfileImage(null);
  }

  ///To init Profile Data
  Future<void> onInit() async {
    print("aaa${UserBloc.instance.user?.cityId!.toJson()!.toString()}");
    fName.text = UserBloc.instance.user?.fname ?? "";
    lName.text = UserBloc.instance.user?.lname ?? "";
    nickname.text = UserBloc.instance.user?.nickname ?? "";
    numberOfChildren.text = UserBloc.instance.user?.numOfSons.toString() ?? "";
    gfName.text = UserBloc.instance.user?.gfName.toString() ?? "";
    gfName.text = UserBloc.instance.user?.glName.toString() ?? "";
    gPhoneNumber.text = UserBloc.instance.user?.gPhoneNumber.toString() ?? "";
    otherGuardian.text = UserBloc.instance.user?.otherGuardian.toString() ?? "";
    updateGender(UserBloc.instance.user?.gender == "M" ? 1 : 2);

      updateNationality(UserBloc.instance.user?.countryId);
      updateOtherNationality(UserBloc.instance.user?.otherNationalityId);
      updateSocialStatus(UserBloc.instance.user?.socialStatus);
      updateCity(UserBloc.instance.user?.cityId);
      updateCountryOfResidence(UserBloc.instance.user?.countryId);

  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      var data = FormData.fromMap({
        "fname": fName.text.trim(),
        "lname": lName.text.trim(),
        // "email": "ahmeedhassanali@outlook.com",
        // "phone": "123456789",
        "country_id": nationality.valueOrNull?.id,
        "city_id": city.valueOrNull?.id ?? 1,
        "dob": dop.valueOrNull?.defaultFormat2(),
        "social_status": socialStatus.valueOrNull?.id,
        "gender": gender.valueOrNull == 1 ? "M" : "F",
        "nickname": nickname.text.trim(),
        "gfname": gfName.text.trim(),
        "glname": glName.text.trim(),
        "gphone": gPhoneNumber.text.trim(),
        "grelation": grelation.valueOrNull?.id,
        "grelation_other": otherGuardian.text.trim(),
        "num_of_sons": numberOfChildren.text.trim() == ""
            ? 0
            : numberOfChildren.text.trim(),
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
        if (identityImage.hasValue)
          "identityFile": MultipartFile.fromFileSync(identityImage.value!.path)
      });
      Either<ServerFailure, Response> response =
          await repo.completeProfile(data, isEdit: event.arguments as bool);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        if (nationality.valueOrNull?.code == "SA") {
          CustomAlertDialog.show(
              dailog: AlertDialog(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  insetPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                      horizontal: 20),
                  shape: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20.0)),
                  content: SubmitSuccessDialog()));
        } else {
          CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
        }

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
