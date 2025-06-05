import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/features/chat/repo/chat_repo.dart';
import '../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../../chats/model/chats_model.dart';
import '../bloc/chat_bloc.dart';
import '../model/message_model.dart';
import '../widgets/chat_bottom_sheet.dart';
import '../widgets/message_cards/message_bubble.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.data});
  final ChatModel data;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  int _limit = 15;
  final int _limitIncrement = 20;
  final ScrollController listScrollController = ScrollController();
  List<MessageModel> listMessage = List.from([]);
  _scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {}
    if (listScrollController.offset <=
        listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      _limit += _limitIncrement;
      print("reach the top");
      setState(() {
        print("reach the top");
      });
    }
  }
  @override
  initState() {
    listScrollController.addListener(_scrollListener);
    super.initState();
  }
  @override
  void dispose() {
    // sl<ChatsBloc>().add(Click(arguments: SearchEngine(isUpdate: true)));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.WHITE_COLOR,

      body: BlocProvider(
        create: (context) => ChatBloc(repo: sl<ChatRepo>()),

        child: Column(
          children: [

            CustomAppBar(
            
                title: widget.data.user?.name??"Doctor name"),
            Expanded(
              child: BlocBuilder<ChatBloc, AppState>(
                builder: (context, state) {
                  return SizedBox(
                    height: context.height,
                    child: SizedBox(
                      height: context.height,
                      child: Column(
                        children: [
                          _getMessageList(),


                        ],
                      ),
                    ),
                  );

                },
              ),
            ),
            BlocBuilder<ChatBloc, AppState>(
              builder: (context, state) {
                return Visibility(
                  visible: state is! Loading,
                  child: ChatBottomSheet(
                    chatId: widget.data.id.toString(),
                    data: widget.data,
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
  Widget _getMessageList() {
    return Expanded(
      child: FirebaseAnimatedList(
        controller: listScrollController,
        // shrinkWrap: true,

        // physics: NeverScrollableScrollPhysics(),
        defaultChild: Center(child: CircularProgressIndicator()),
        query: ref
            .child("messages")
            .child(widget.data.id.toString())
            .limitToLast(_limit),
        itemBuilder: (context, snapshot, animation, index) {
          listMessage = [];
          final json = snapshot.value as Map<dynamic, dynamic>;
          final message = MessageModel.fromJson(json);
          listMessage.add(message);
          return MessageBubble(
            addDate: true,
            chat: message,
          );
        },
      ),
    );
  }
}
