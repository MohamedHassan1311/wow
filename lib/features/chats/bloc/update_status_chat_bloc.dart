import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/loading_dialog.dart';
import 'package:wow/features/chats/bloc/chats_bloc.dart';
import 'package:wow/main_models/search_engine.dart';
import 'package:wow/navigation/custom_navigation.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../data/config/di.dart';
import '../repo/chats_repo.dart';

class UpdateStatusChatBloc extends Bloc<AppEvent, AppState> {
  final ChatsRepo repo;

  UpdateStatusChatBloc({required this.repo}) : super(Start()) {
    on<Update>(onUpdate);
  }
  TextEditingController reasonController = TextEditingController();

  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    try {
      emit(Loading());
      final Map<String, dynamic> arguments =
          event.arguments as Map<String, dynamic>;

      Either<ServerFailure, Response> response =
          await repo.updateChat(arguments['id'], arguments['status'],reasonController.text.trim()
          );
      CustomNavigator.pop();
      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        if (arguments['status'] == 3) {
          CustomNavigator.pop();
        }
        sl<ChatsBloc>().add(Click(arguments: SearchEngine()));
        AppCore.showSnackBar(
            notification: AppNotification(
          message: getTranslated("the_chat_has_been_deleted_successfully"),
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
      emit(Error());
    }
  }
}
