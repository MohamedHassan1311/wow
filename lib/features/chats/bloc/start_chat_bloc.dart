
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../navigation/routes.dart';
import '../model/chats_model.dart';
import '../repo/chats_repo.dart';

class StartChatBloc extends Bloc<AppEvent, AppState> {
  final ChatsRepo repo;

  StartChatBloc({required this.repo}) : super(Start()) {
    on<Send>(onSend);
  }

  Future<void> onSend(Send event, Emitter<AppState> emit) async {
    try {
      emit(Loading());

      Either<ServerFailure, Response> response = await repo.startChat(
           doctor_id: event.arguments as int);
      response.fold((fail) {
        
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        // final chatModel = ChatModel.fromJson(success.data['data'],fromCreate: true);
          CustomNavigator.push(
          Routes.dashboard,
          clean: true,
          arguments: 3,
        );

        emit(Done());
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
