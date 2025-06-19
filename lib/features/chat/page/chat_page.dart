import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/custom_bottom_sheet.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/features/chat/repo/chat_repo.dart';
import 'package:wow/features/chats/bloc/chats_bloc.dart';
import 'package:wow/features/chats/bloc/update_status_chat_bloc.dart';
import 'package:wow/features/chats/repo/chats_repo.dart';
import 'package:wow/features/more/widgets/more_button.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
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
              isCenter: false,
              title: widget.data.user?.nickname ?? "name",
              actionWidth: 80.w,
              actionChild: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        CustomBottomSheet.show(
                          height: 300.h,
                          label: getTranslated("more"),
                          widget: Column(
                            children: [
                              BlocProvider(
                                create: (context) =>
                                    UpdateStatusChatBloc(repo: sl<ChatsRepo>()),
                                child:
                                    BlocBuilder<UpdateStatusChatBloc, AppState>(
                                        builder: (context, state) {
                                  return MoreButton(
                                    title: getTranslated("end_chat",
                                        context: context),
                                    icon: SvgImages.close,
                                    onTap: () {
                                      context.read<UpdateStatusChatBloc>().add(
                                              Update(arguments: {
                                            "id": widget.data.id,
                                            "status": 3
                                          }));
                                    },
                                  );
                                }),
                              ),
                              MoreButton(
                                title:
                                    getTranslated("report", context: context),
                                icon: SvgImages.report,
                                onTap: () {
                                  CustomNavigator.pop();
                                  CustomNavigator.push(Routes.addToReportPage,
                                      arguments: {
                                        "user": widget.data.user,
                                        "isFromChat": true
                                      });
                                },
                              ),
                              MoreButton(
                                title: getTranslated("block", context: context),
                                icon: SvgImages.rejectedUsers,
                                onTap: () {
                                  CustomNavigator.pop();

                                  CustomNavigator.push(Routes.AddToBlockPage,
                                      arguments: {
                                        "user": widget.data.user,
                                        "isFromChat": true
                                      });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.more_vert)),
                ],
              ),
            ),
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
                   if (widget.data.status != 2&&widget.data.status != 4)
            SafeArea(
              child: Column(
                children: [
                  customImageIconSVG(
                      imageName: SvgImages.close,
                      height: 80,
                      color: Styles.ERORR_COLOR),
                        Text(
                          context.read<ChatsBloc>().getStatusMassage(
                                  widget.data.status!, widget.data.user?.nickname ?? "") ??
                              "",
                          style: AppTextStyles.w700
                              .copyWith(fontSize: 18, color: Styles.BLACK),
                        ),
                ],
              ),
            ),
            if (widget.data.status == 2||widget.data.status == 4 )
              BlocBuilder<ChatBloc, AppState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state is! Loading,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ChatBottomSheet(
                          chatId: widget.data.id.toString(),
                          data: widget.data,
                        ),
                        customImageIconSVG(
                          width: 60,
                          imageName: SvgImages.faq,
                          onTap: () {
                            CustomBottomSheet.show(
                              height: 300.h,
                              label: getTranslated("frequently_questions"),
                              buttonText: getTranslated("send"),
                              widget: ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: context
                                    .read<ChatBloc>()
                                    .frequentlyQuesions
                                    .length,
                                itemBuilder: (context2, index) {
                                  return InkWell(
                                    onTap: () {
                                      CustomNavigator.pop();

                                      context.read<ChatBloc>().controller.text =
                                          context
                                              .read<ChatBloc>()
                                              .frequentlyQuesions[index];
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 10.w),
                                        child: Text(
                                          context
                                              .read<ChatBloc>()
                                              .frequentlyQuesions[index],
                                          style: AppTextStyles.w600.copyWith(
                                              fontSize: 16,
                                              color: Styles.HEADER),
                                        )),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
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
