import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/navigation/custom_navigation.dart';

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
import '../repo/perosnal_info_repo.dart';

class PersonalInfoBloc extends Bloc<AppEvent, AppState> {
  final PersonalInfoRepo repo;
  PersonalInfoBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    updateCurrentStep(1);
  }

  final TextEditingController otherJob = TextEditingController();
  final TextEditingController salery = TextEditingController();
  final TextEditingController weight = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController otherTribe = TextEditingController();
  final TextEditingController personalInfo = TextEditingController();
  final TextEditingController partenrInfo = TextEditingController();
  final TextEditingController otherGuardian = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();
  final formKey6 = GlobalKey<FormState>();
  final job = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateJob => job.sink.add;
  Stream<CustomFieldModel?> get jobStream => job.stream.asBroadcastStream();

  final education = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateEducation => education.sink.add;
  Stream<CustomFieldModel?> get educationStream =>
      education.stream.asBroadcastStream();

  final education2 = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateEducation2 => education2.sink.add;
  Stream<CustomFieldModel?> get education2Stream =>
      education2.stream.asBroadcastStream();

  final languages = BehaviorSubject<List<int>?>();
  Function(List<int>?) get updateLanguages => languages.sink.add;
  Stream<List<int>?> get languagesStream =>
      languages.stream.asBroadcastStream();

  final skinColor = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateSkinColor => skinColor.sink.add;
  Stream<CustomFieldModel?> get skinColorStream =>
      skinColor.stream.asBroadcastStream();

  final bodyType = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateBodyType => bodyType.sink.add;
  Stream<CustomFieldModel?> get bodyTypeStream =>
      bodyType.stream.asBroadcastStream();

  final Sect = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateSect => Sect.sink.add;
  Stream<CustomFieldModel?> get SectStream => Sect.stream.asBroadcastStream();

  final tribe = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateTribe => tribe.sink.add;
  Stream<CustomFieldModel?> get tribeStream => tribe.stream.asBroadcastStream();

  final hijab = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateHijab => hijab.sink.add;
  Stream<CustomFieldModel?> get hijabStream => hijab.stream.asBroadcastStream();

  final abaya = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateAbaya => abaya.sink.add;
  Stream<CustomFieldModel?> get abayaStream => abaya.stream.asBroadcastStream();

  final accountType = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateAccountType => accountType.sink.add;
  Stream<CustomFieldModel?> get accountTypeStream => accountType.stream.asBroadcastStream();

  final culture = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCulture => culture.sink.add;
  Stream<CustomFieldModel?> get cultureStream => culture.stream.asBroadcastStream();

  final health = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateHealth => health.sink.add;
  Stream<CustomFieldModel?> get healthStream => health.stream.asBroadcastStream();

  final lifestyle = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateLifestyle => lifestyle.sink.add;
  Stream<CustomFieldModel?> get lifestyleStream => lifestyle.stream.asBroadcastStream();

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
      return "education";
    }
    if (step == 2) {
      return "job";
    }
    if (step == 3) {
      return "shape";
    }
    if (step == 4) {
      return "Sect and tribe";
    
    }

    if (step == 5) {
      return "fashion_style";
    } 
    if (step == 6) {
      return "introduction";
    } 
    else
      return "";
  }

  Future<void> onInit() async {

print(UserBloc.instance.user!.languages.toString()+"languagess") ;
    updateEducation(UserBloc.instance.user?.education);
    updateEducation2(UserBloc.instance.user?.education2);
    updateJob(CustomFieldModel(name: UserBloc.instance.user?.job));
    updateBodyType(UserBloc.instance.user?.bodyType);
    updateSkinColor(UserBloc.instance.user?.skinColor);
    updateTribe(UserBloc.instance.user?.tribe);
    updateSect(UserBloc.instance.user?.sect);
    updateLanguages(UserBloc.instance.user?.languages);
    height.text = UserBloc.instance.user!.height.toString();
    weight.text = UserBloc.instance.user!.weight.toString();
    personalInfo.text = UserBloc.instance.user?.personalInfo ?? "";
    partenrInfo.text = UserBloc.instance.user?.partenrInfo ?? "";
        salery.text = UserBloc.instance.user?.salary ?? "";

    updateAccountType(UserBloc.instance.user?.accountType);
    updateCulture(UserBloc.instance.user?.culture);
    updateHealth(UserBloc.instance.user?.health);
    updateLifestyle(UserBloc.instance.user?.lifestyle);

  }

  clear() {
    // updateProfileImage(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      var data = FormData.fromMap({
        "education": education.valueOrNull?.id,
        "education_2": education2.valueOrNull?.id,

        "job_title": job.valueOrNull?.name ?? otherJob.text.trim(),
        "salary": salery.text.trim(),
        "height": height.text.trim(),
        "weight": weight.text.trim(),
        "body_type": bodyType.valueOrNull?.id,
        "complexion": skinColor.valueOrNull?.id,
        "tribe": tribe.valueOrNull?.id,
        "religion": Sect.valueOrNull?.id,
        "about_me": personalInfo.text,
        "about_partner": partenrInfo.text,
        "languages[]":languages.valueOrNull,
        "culture": culture.valueOrNull?.id,
        "health": health.valueOrNull?.id,
        "lifestyle": lifestyle.valueOrNull?.id,
        "account_type": accountType.valueOrNull?.id,
        //
        if(identityImage.hasValue)
        "image":identityImage.hasValue? MultipartFile.fromFileSync(identityImage.value?.path ?? ""):null
      });
      print(data);
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
        AppCore.showSnackBar(
            notification: AppNotification(
                message: getTranslated("your_profile_successfully_updated"),
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Colors.transparent));

        UserBloc.instance.add(Click());
        emit(Done());
        CustomNavigator.pop();
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
