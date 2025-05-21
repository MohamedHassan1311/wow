import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/features/Favourit/repo/favourit_repo.dart';
import 'package:wow/main_models/user_model.dart';

import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/internet_connection/internet_connection.dart';


class FavouritBloc extends HydratedBloc<AppEvent, AppState> {
  final FavouritRepo repo;
  final InternetConnection internetConnection;

  FavouritBloc({required this.repo, required this.internetConnection})
      : super(Start()) {
    on<Get>(onGet); 
    on<Add>(onAdd);
  }

  CarouselSliderController bannerController = CarouselSliderController();

  BehaviorSubject<int> index = BehaviorSubject();
  Function(int) get updateIndex => index.sink.add;
  Stream<int> get indexStream => index.stream.asBroadcastStream();

       List<UserModel> users = [];

       

  Future<void> onGet(Get event, Emitter<AppState> emit) async {
    if (await internetConnection.updateConnectivityStatus()) {
      // try {
        emit(Loading());

        Either<ServerFailure, Response> response = await repo.getFavourit(likedYou: event.arguments == 0);

        response.fold((fail) {
          AppCore.showSnackBar(
              notification: AppNotification(
                  message: fail.error,
                  isFloating: true,
                  backgroundColor: Styles.IN_ACTIVE,
                  borderColor: Colors.red));
          emit(Error());
        }, (success) {
        
               users = List<UserModel>.from(
            success.data['data'].map((e) => UserModel.fromJson(e)));

            if(users.isNotEmpty){
              emit(Done());
            }
            else{
              emit(Empty());
            }
        });
      // } catch (e) {
      //   AppCore.showSnackBar(
      //       notification: AppNotification(
      //     message: e.toString(),
      //     backgroundColor: Styles.IN_ACTIVE,
      //     borderColor: Styles.RED_COLOR,
      //   ));
      //   emit(Error());
      // }
    }
  }


onAdd(Add event, Emitter<AppState> emit) async {
  if (await internetConnection.updateConnectivityStatus()) {
    try { 
      emit(Loading());

      Either<ServerFailure, Response> response = await repo.addtoFavourit(event.arguments as int);

        response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Styles.RED_COLOR,
              ));
          emit(Error());
        }, (success) {
            AppCore.showSnackBar(
            notification: AppNotification(
                message: success.data['message'],
                isFloating: true,
                backgroundColor: Styles.ACTIVE,
                borderColor: Styles.ACTIVE,
              ));
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
