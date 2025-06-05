import 'dart:async';
import 'dart:developer';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../app/core/app_core.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_notification.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../data/error/failures.dart';
import '../entity/message_entity.dart';
import '../entity/typing_entity.dart';
import '../model/message_model.dart';
import '../repo/chat_repo.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class ChatBloc extends Bloc<AppEvent, AppState> {
  final ChatRepo repo;
  io.Socket? socket;

  ChatBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<SendMessage>(sendMessage);
    on<ReceiveMessage>(receiveMessage);
    on<Typing>(onTypingUser);
  }

  final isRecording = BehaviorSubject<bool?>();
  Function(bool?) get updateIsRecording => isRecording.sink.add;
  Stream<bool?> get isRecordingStream => isRecording.stream.asBroadcastStream();

  final message = BehaviorSubject<MessageEntity>();
  Function(MessageEntity) get updateMessage => message.sink.add;
  Stream<MessageEntity> get messageStream => message.stream.asBroadcastStream();

  @override
  Future<void> close() {
    message.close();
    isRecording.close();
    disconnect();
    return super.close();
  }


  chatMessageListener() {
    socket?.on('sendChatToClient', (data) {
      log("$data");
      add(ReceiveMessage(
          message: MessageItem.fromJson(data['data'] as Map<String, dynamic>)));
    });
  }

  ///UserTyping Channel
  final typing = BehaviorSubject<TypingEntity>();
  Function(TypingEntity) get updateTyping => typing.sink.add;
  Stream<TypingEntity> get typingStream => typing.stream.asBroadcastStream();

  userTypingListener() {
    socket?.on('userTyping', (data) {
      log("===>On listen Typing ${data["userTyping"]}");

      updateTyping(typing.value.copyWith(userTyping: data["userTyping"] == 1));
    });
  }

  Future<void> onTypingUser(Typing event, Emitter<AppState> emit) async {
    socket?.emit(
      'chat-typing-${typing.value.chatId}',
      {"userTyping": typing.value.meTyping == true ? 1 : 0},
    );
  }

  void disconnect() {
    socket?.close();
    socket?.disconnect();
    socket?.clearListeners();
    socket?.dispose();
    socket = null;
  }

  MessagesModel? model;
  onClick(Click event, Emitter<AppState> emit) async {
    emit(Loading());

    try {
      Either<ServerFailure, Response> response =
          await repo.getChatDetails(event.arguments as int);

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        model = MessagesModel.fromJson(success.data);

        if (model?.messages != null && model!.messages!.isNotEmpty) {
          emit(Done(model: model));
        } else {
          emit(Empty());
        }
      });
    } catch (e) {
      AppCore.showSnackBar(
          notification: AppNotification(
              message: e.toString(),
              isFloating: true,
              backgroundColor: Styles.IN_ACTIVE,
              borderColor: Colors.red));

      emit(Error());
    }
  }

  sendMessage(SendMessage event, Emitter<AppState> emit) async {

    final map = event.arguments as Map;
    Either<ServerFailure, String> apiResponse =
    await repo.sendMessage(
        photo: message.valueOrNull?.message,
        message: map["message"], receiverId: map["receiverId"].toString() , convId: map["convId"].toString());
    apiResponse.fold((l) {
      print("faill");
    }, (success) {
      updateMessage(
        MessageEntity(),

      );
      print(success);

    });
  }

  Future<void> receiveMessage(
      ReceiveMessage event, Emitter<AppState> emit) async {
    model!.messages!.add(event.message as MessageItem);

    emit(Done(model: model));
  }
}
