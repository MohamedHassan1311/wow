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
import '../../../main_models/custom_field_model.dart';
import '../repo/perosnal_info_repo.dart';

class PersonalInfoBloc extends Bloc<AppEvent, AppState> {
  final PersonalInfoRepo repo;
  PersonalInfoBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    updateCurrentStep(1);
    updateDOP(DateTime(1999));
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

  final job = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateJob => job.sink.add;
  Stream<CustomFieldModel?> get jobStream =>
      job.stream.asBroadcastStream();

  final education = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateEducation =>
      education.sink.add;
  Stream<CustomFieldModel?> get educationStream =>
      education.stream.asBroadcastStream();

  final education2 = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateEducation2 =>
      education2.sink.add;
  Stream<CustomFieldModel?> get education2Stream =>
      education2.stream.asBroadcastStream();


  final languages = BehaviorSubject<List<int>?>();
  Function(List<int>?) get updateLanguages=>
      languages.sink.add;
  Stream<List<int>?> get languagesStream =>
      languages.stream.asBroadcastStream();

  final skinColor = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateSkinColor => skinColor.sink.add;
  Stream<CustomFieldModel?> get skinColorStream => skinColor.stream.asBroadcastStream();

  final bodyType = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateBodyType => bodyType.sink.add;
  Stream<CustomFieldModel?> get bodyTypeStream =>
      bodyType.stream.asBroadcastStream();

  final Sect = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateSect => Sect.sink.add;
  Stream<CustomFieldModel?> get SectStream => Sect.stream.asBroadcastStream();

  final tribe = BehaviorSubject<CustomFieldModel?>();
  Function(CustomFieldModel?) get updateTribe=> tribe.sink.add;
  Stream<CustomFieldModel?> get tribeStream =>
      tribe.stream.asBroadcastStream();

  final dop = BehaviorSubject<DateTime?>();
  Function(DateTime?) get updateDOP => dop.sink.add;
  Stream<DateTime?> get dopStream => dop.stream.asBroadcastStream();



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
      return "introduction";
    } else
      return "";
  }

  clear() {
    // updateProfileImage(null);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {

      emit(Loading());
      var data =  FormData.fromMap({

        "education": education.valueOrNull?.id,
        "education_2": education2.valueOrNull?.id,

        "job_title": job.valueOrNull?.id,
        "salary": salery.text.trim(),
        "height": height.text.trim(),
        "weight": weight.text.trim(),
        "body_type": bodyType.valueOrNull?.id,
        "complexion": skinColor.valueOrNull?.id,
        "tribe": tribe.valueOrNull?.id,
        "religion": Sect.valueOrNull?.id,
        "about_me": personalInfo.text,
        "about_partner": partenrInfo.text,
        //
        "image": MultipartFile.fromFileSync(identityImage.value!.path)
      });
      print(data);
      Either<ServerFailure, Response> response =
          await repo.completeProfile(data);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        // CustomAlertDialog.show(
        //     dailog: AlertDialog(
        //         contentPadding: EdgeInsets.symmetric(
        //             vertical:
        //             Dimensions.PADDING_SIZE_DEFAULT.w,
        //             horizontal:
        //             Dimensions.PADDING_SIZE_DEFAULT.w),
        //         insetPadding: EdgeInsets.symmetric(
        //             vertical:
        //             Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
        //             horizontal: 20),
        //         shape: OutlineInputBorder(
        //             borderSide: const BorderSide(
        //                 color: Colors.transparent),
        //             borderRadius:
        //             BorderRadius.circular(20.0)),
        //         content:SubmitSuccessDialog()
        //     ));



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
