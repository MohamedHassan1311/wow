import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/localization/language_constant.dart';
import '../../../../app/core/app_core.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_notification.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/styles.dart';
import '../../../../data/error/failures.dart';
import '../../../main_models/search_engine.dart';
import '../model/chats_model.dart';
import '../repo/chats_repo.dart';
import '../widgets/chat_card.dart';

class ChatsBloc extends Bloc<AppEvent, AppState> {
  final ChatsRepo repo;

  ChatsBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
    on<Update>(onUpdate);
  }




  String? getStatusMassage(int status , String name) {
    print(status);

       if (status == 1 ) {
      // ignore: unnecessary_string_interpolations
      return "${getTranslated("watting_for_approve_chat")}" ;
    } 
     if (status == 2 || status ==4) {
      return "${getTranslated("start_to_chat_with")} ${name}" ;
    } 
    else if (status == 3) {
        return getTranslated("chat_is_ended",).replaceAll("#", name);
      } 
         else if (status == 5) {
        return getTranslated("chat_is_rejected",).replaceAll("#", name);
      }
        else if (status == 6) {
        return getTranslated("chat_is_exspierd",).replaceAll("#", name);
      }
        else if (status == 7) {
    return getTranslated("chat_is_cancelled",).replaceAll("#", name);
      }
    
     return null; 

  }

  late SearchEngine _engine;
List<Widget>? _cards;

  customScroll(ScrollController controller) {
    bool scroll = AppCore.scrollListener(
        controller, _engine.maxPages, _engine.currentPage!);
    if (scroll) {
      _engine.updateCurrentPage(_engine.currentPage!);
      add(Click(arguments: _engine));
    }
  }

  Future<void> onClick(Click event, Emitter<AppState> emit) async {
    try {
       emit(Loading());
  _cards =[];
      Either<ServerFailure, Response> response = await repo.getChats(SearchEngine());

      response.fold((fail) {
        AppCore.showSnackBar(
            notification: AppNotification(
                message: fail.error,
                isFloating: true,
                backgroundColor: Styles.IN_ACTIVE,
                borderColor: Colors.red));
        emit(Error());
      }, (success) {
        ChatsModel? model = ChatsModel.fromJson(success.data);
        print(model.data);
          for (var chat in model.data!) {
            _cards?.add(ChatCard(key: ValueKey(chat.id), chat: chat));
          }
          if(model.data!.isNotEmpty){

          emit(Done(cards: _cards, loading: false));
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

  ///Update Cards When Delete a card
  Future<void> onUpdate(Update event, Emitter<AppState> emit) async {
    _cards?.removeWhere((e) =>
        (e.key as ValueKey<int?>).value ==
        ValueKey(event.arguments as int).value);
    if (_cards != null && _cards!.isNotEmpty) {
      emit(Done(cards: _cards));
    } else {
      emit(Empty());
    }
  }
}
