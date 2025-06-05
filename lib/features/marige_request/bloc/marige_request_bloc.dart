import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path/path.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_alert_dialog.dart';
import 'package:wow/components/loading_dialog.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/marige_request/model/mairdege_model.dart';
import 'package:wow/features/marige_request/repo/marige_request_repo.dart';
import 'package:wow/features/profile_details/widgets/maridge_request_dialog.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';

class MarigeRequestBloc extends HydratedBloc<AppEvent, AppState> {
  final MarigeRequestRepo repo;
  final InternetConnection internetConnection;

  MarigeRequestBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Get>(onGet);
    on<Send>(onSend);
    on<Accept>(onAccept);
    on<Reject>(onReject);
    on<Delete>(onCancel);
  }

  CarouselSliderController bannerController = CarouselSliderController();

  BehaviorSubject<int> index = BehaviorSubject();
  Function(int) get updateIndex => index.sink.add;
  Stream<int> get indexStream => index.stream.asBroadcastStream();
  ProposalResponse? recommendations;
  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        emit(Loading());
      
        Either<ServerFailure, Response> response =
            await repo.getMarigeRequest();

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
          if (success.data['data'].isNotEmpty) {
            recommendations = ProposalResponse.fromJson(success.data);
          
          }

          if (recommendations?.data.isNotEmpty ?? false) {
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

  Future<void> onSend(Send event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        loadingDialog();
     
        Either<ServerFailure, Response> response =
            await repo.sendMarigeRequest(event.arguments as int);
        CustomNavigator.pop();
        response.fold((fail) async {
          
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
        }, (success) async {
         await CustomAlertDialog.show(
              dailog: AlertDialog(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                      horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                  insetPadding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                      horizontal:
                          CustomNavigator.navigatorState.currentContext!.width *
                              0.1),
                  shape: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(20.0)),
                  content: MaridgeRequestDialog(
                    name: getTranslated("marige_request"),
                    discription:
                        getTranslated("marige_request_sent_successfully"),
                    image: SvgImages.ring,
                    confirmButtonText: getTranslated("go_to_maridge_req_page"),
                    showBackButton: false,
                  )));

          CustomNavigator.push(Routes.dashboard, arguments: 2);
        });
      } catch (e) {
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
      }
    }
  }



  Future<void> onAccept(Accept event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        loadingDialog();
     
        Either<ServerFailure, Response> response =
            await repo.acceptMarigeRequest(event.arguments as int);
        CustomNavigator.pop();
        response.fold((fail) async {
          
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
        }, (success) async {
          sl<MarigeRequestBloc>().add(Get());
         AppCore.showSnackBar(
              notification: AppNotification(
                  message: success.data['message'],
                  isFloating: true,
                  backgroundColor: Styles.ACTIVE,
                  borderColor: Colors.green));
                  emit(Done());
        });
      } catch (e) {
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
      }
    }
  }


  Future<void> onReject(Reject event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        loadingDialog();
     
        Either<ServerFailure, Response> response =
            await repo.rejectMarigeRequest(event.arguments as int);
        CustomNavigator.pop();
        response.fold((fail) async {
          
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
        }, (success) async {
                    sl<MarigeRequestBloc>().add(Get());

         AppCore.showSnackBar(
              notification: AppNotification(
                  message: success.data['message'],
                  isFloating: true,
                  backgroundColor: Styles.ACTIVE,
                  borderColor: Colors.green));
                  emit(Done());
    
        });
      } catch (e) {
        
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
      }
    }
  }

  Future<void> onCancel(Delete event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      try {
        loadingDialog();
     
        Either<ServerFailure, Response> response =
            await repo.cancelMarigeRequest(event.arguments as int);
        CustomNavigator.pop();
        response.fold((fail) async {
          
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
        }, (success) async {
                    sl<MarigeRequestBloc>().add(Get());

         AppCore.showSnackBar(
              notification: AppNotification(
                  message: success.data['message'],
                  isFloating: true,
                  backgroundColor: Styles.ACTIVE,
                  borderColor: Colors.green));
                  emit(Done());
    
        });
      } catch (e) {
        AppCore.showSnackBar(
            notification: AppNotification(
          message: e.toString(),
          backgroundColor: Styles.IN_ACTIVE,
          borderColor: Styles.RED_COLOR,
        ));
      }
    }
  }



  @override
  AppState? fromJson(Map<String, dynamic> json) {
    try {
      if (json['state'] == "Start") {
        return Loading();
      }
      if (json['state'] == "Error") {
        return Error();
      }
      if (json['state'] == "Loading") {
        return Loading();
      }
      if (json['state'] == "Done") {
        return Done(
          loading: jsonDecode(json['loading']) as bool,
        );
      }
      return Start();
    } catch (e) {
      return Error();
    }
  }

  @override
  Map<String, dynamic>? toJson(AppState? state) => state?.toJson();
}
