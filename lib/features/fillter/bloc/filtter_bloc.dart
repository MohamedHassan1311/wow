import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';

import '../../../main_blocs/user_bloc.dart';
import '../../../main_models/custom_field_model.dart';

import '../repo/fillter_repo.dart';

class FilterBloc extends Bloc<AppEvent, AppState> {
  final FillterRepo repo;
  FilterBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();

  final nationality = BehaviorSubject<CustomFieldModel?>()
    ..add(CustomFieldModel());

  Function(CustomFieldModel?) get updateNationality => nationality.sink.add;
  Stream<CustomFieldModel?> get nationalityStream => nationality.stream;

  final socialStatus = BehaviorSubject<CustomFieldModel?>()
    ..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateSocialStatus => socialStatus.sink.add;
  Stream<CustomFieldModel?> get socialStatusStream => socialStatus.stream;

  final category = BehaviorSubject<CustomFieldModel?>()
    ..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCategory => category.sink.add;
  Stream<CustomFieldModel?> get categoryStream => category.stream;

  final health = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateHealth => health.sink.add;
  Stream<CustomFieldModel?> get healthStream => health.stream;

  final lifestyle = BehaviorSubject<CustomFieldModel?>()
    ..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateLifestyle => lifestyle.sink.add;
  Stream<CustomFieldModel?> get lifestyleStream => lifestyle.stream;

  final abya = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateAbya => abya.sink.add;
  Stream<CustomFieldModel?> get abyaStream => abya.stream;

  final hijab = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateHijab => hijab.sink.add;
  Stream<CustomFieldModel?> get hijabStream => hijab.stream;

  final country = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCountry => country.sink.add;
  Stream<CustomFieldModel?> get countryStream => country.stream;

  final city = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCity => city.sink.add;
  Stream<CustomFieldModel?> get cityStream => city.stream;

  final culture = BehaviorSubject<CustomFieldModel?>()..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateCulture => culture.sink.add;
  Stream<CustomFieldModel?> get cultureStream => culture.stream;

  List<String> ageList = [
    '18 - 24',
    '25 - 32',
    '33 - 40',
    '41 - 48',
    '49 - 56',
    '57 - 64',
    '65 - 72',
    '73 - 80'
  ];

  final age = BehaviorSubject<String?>()..add(null);
  Function(String?) get updateAge => age.sink.add;
  Stream<String?> get ageStream => age.stream;

  final gender = BehaviorSubject<int?>()..add(1);
  Function(int?) get updateGender => gender.sink.add;
  Stream<int?> get genderStream => gender.stream;

  final grelation = BehaviorSubject<CustomFieldModel?>()
    ..add(CustomFieldModel());
  Function(CustomFieldModel?) get updateGrelation => grelation.sink.add;
  Stream<CustomFieldModel?> get GrelationStream => grelation.stream;

  ///To init Profile Data
  Future<void> onInit() async {
    updateGender(UserBloc.instance.user?.gender == "M" ? 1 : 2);

    updateSocialStatus(UserBloc.instance.user?.socialStatus);
  }

  List<UserModel> users = [];
  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    // try {
      emit(Loading());

      Either<ServerFailure, Response> response = await repo.submitFilter(
        {
          if (age.value != null)
            "age_min": age.value?.split("-")[0],

            "age_max": age.value?.split("-")[1],
          if (socialStatus.value?.id != null)
            "social_status": socialStatus.value?.id,
          if (health.value?.id != null) "health": health.value?.id,
          if (hijab.value?.id != null) "hijab": hijab.value?.id,
          if (abya.value?.id != null) "abaya": abya.value?.id,
          if (culture.value?.id != null) "culture": culture.value?.id,
          if (city.value?.id != null) "city": city.value?.id,
          if (lifestyle.value?.id != null) "lifestyle": lifestyle.value?.id,
          if (category.value?.id != null) "account_type": category.value?.id,

        },
      );

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        users = List<UserModel>.from(
            success.data['data'].map((e) => UserModel.fromJson(e)));
        CustomNavigator.push(Routes.filterResult);

        emit(Done());
      });
    // } catch (e) {
    //   print(e);
    //   AppCore.showSnackBar(
    //     notification: AppNotification(
    //       message: e.toString(),
    //       backgroundColor: Styles.IN_ACTIVE,
    //       borderColor: Styles.RED_COLOR,
    //     ),
    //   );
    //   emit(Error());
    // }
  }
}
