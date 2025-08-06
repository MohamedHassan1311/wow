import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/features/auth/login/entity/login_entity.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/features/auth/verification/model/verification_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_alert_dialog.dart';
import '../../../../components/custom_simple_dialog.dart';
import '../../../../data/error/failures.dart';
import '../../../../main_blocs/user_bloc.dart';
import '../../../../main_widgets/custom_request_dialog.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../activation_account/view/activation_dialog.dart';
import '../repo/login_repo.dart';

class LoginBloc extends Bloc<AppEvent, AppState> {
  final LoginRepo repo;
  LoginBloc({required this.repo}) : super(Start()) {
    updateRememberMe(false);

    on<Add>(onAdd);
    on<Click>(onClick);
    on<Remember>(onRemember);
  }

  final formKey = GlobalKey<FormState>();
  final FocusNode emailNode = FocusNode();
  final FocusNode passwordNode = FocusNode();

  final loginEntity = BehaviorSubject<LoginEntity?>();
  Function(LoginEntity?) get updateLoginEntity => loginEntity.sink.add;
  Stream<LoginEntity?> get loginEntityStream =>
      loginEntity.stream.asBroadcastStream();

  Future<bool> isBodyValid() async {
    for (var entry in (await loginEntity.valueOrNull?.toJson() ?? {}).entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return false;
      }
    }
    return true;
  }

  final rememberMe = BehaviorSubject<bool?>();
  Function(bool?) get updateRememberMe => rememberMe.sink.add;
  Stream<bool?> get rememberMeStream => rememberMe.stream.asBroadcastStream();

  clear() {
    updateLoginEntity(LoginEntity(
      email: TextEditingController(),
      password: TextEditingController(),
    ));
    updateRememberMe(false);
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
      if (isBodyValid() == false) {
        return;
      }
      emit(Loading());

      Either<ServerFailure, Response> response =
          await repo.logIn(await loginEntity.valueOrNull!.toJson());

      response.fold((fail) {
        emit(Error());
print(fail.statusCode );
        if (fail.statusCode == 406) {
          CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            withContentPadding: false,
            customWidget: ActivationDialog(
              email: loginEntity!.value!.email!.text,
            ),
          );
          return;
        }
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.transparent));
      }, (success) {
        if (rememberMe.valueOrNull == true) {
          repo.saveCredentials(loginEntity.valueOrNull!.toJson());
        }
        UserBloc.instance.add(Click());

        if (success.data['data'] != null &&
            success.data['data']["client"]["email_verified"] != 1) {
          CustomNavigator.push(
            Routes.verification,
            arguments: VerificationModel(
                email: loginEntity.valueOrNull?.email?.text.trim() ?? "",
                fromForgetPass: false,
                fromLogin: true,
                fromRegister: true),
          );
          return;
        } else {
          if (success.data['data'] != null &&
              success.data['data']["client"]["social_status"] == null) {
            CustomNavigator.push(Routes.CompleteProfile, clean: true);
            CustomAlertDialog.show(
                dailog: AlertDialog(
                    contentPadding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                    shape: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(20.0)),
                    content: CustomDialog(
                      name: getTranslated("welcome"),
                      showBackButton: false,
                      confirmButtonText: getTranslated("ok"),
                      showSympole: false,
                      discription: getTranslated("personal_info_notice"),
                      image: SvgImages.info,
                    )));
          } else {
            CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
          }
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

  Future<void> onRemember(Remember event, Emitter<AppState> emit) async {
    Map<String, dynamic>? data = repo.getCredentials();
    if (data != null) {
      updateLoginEntity(LoginEntity(
        email: TextEditingController(text: data["email"]),
        password: TextEditingController(text: data["password"]),
      ));
      updateRememberMe(data["email"] != "" && data["password"] != null);
      emit(Done());
    }
  }

  Future<void> onAdd(Add event, Emitter<AppState> emit) async {
    repo.guestMode();
    CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
    emit(Start());
  }
}
