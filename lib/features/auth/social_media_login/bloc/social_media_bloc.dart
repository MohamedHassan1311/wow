import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/features/auth/social_media_login/repo/social_media_repo.dart';
import 'package:wow/helpers/social_media_login_helper.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_blocs/user_bloc.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../verification/model/verification_model.dart';

class SocialMediaBloc extends Bloc<AppEvent, AppState> {
  final SocialMediaRepo repo;
  SocialMediaBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response = await repo
          .signInWithSocialMedia(event.arguments as SocialMediaProvider);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
        emit(Error());
      }, (success) {
        UserBloc.instance.add(Click());

        if (success.data['data'] != null &&
            success.data['data']["client"]["email_verified"] != 1) {
          CustomNavigator.push(
            Routes.verification,
            arguments: VerificationModel(
                email:  success.data['data']["client"]["email"]?? "",
                fromForgetPass: false,
                fromLogin: true,
                fromRegister: true),
          );
          return;
        } else
        {
          if (success.data['data'] != null &&
              success.data['data']["client"]["social_status"] == null) {
            CustomNavigator.push(Routes.CompleteProfile, clean: true);
          }else {

            CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
          }
        }
        emit(Done());
      });
    } catch (e) {
      AppCore.showSnackBar(
        notification: AppNotification(
          message:  getTranslated("something_went_wrong"),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ),
      );
      emit(Error());
    }
  }
}
