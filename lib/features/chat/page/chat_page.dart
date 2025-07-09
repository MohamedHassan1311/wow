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
  bool isFirstLoad = true;

  _scrollListener() {
    if (listScrollController.offset <=
        listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      _limit += _limitIncrement;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    listScrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusManager.instance.addListener(() {
        if (FocusManager.instance.primaryFocus?.hasFocus == true) {
          Future.delayed(Duration(milliseconds: 300), () {
            if (listScrollController.hasClients) {
              listScrollController.animateTo(
                listScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      });
    });

  }

  @override
  void dispose() {
    listScrollController.removeListener(_scrollListener);
    listScrollController.dispose();
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
              actionWidth: 180.w,
              actionChild: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Styles.Orange,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(getTranslated("days_on_expire").replaceAll(
                          "&", widget.data.remaining_days.toString())),
                    ),
                  ),
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
                              child: BlocBuilder<UpdateStatusChatBloc, AppState>(
                                builder: (context, state) {
                                  return MoreButton(
                                    title: getTranslated("end_chat", context: context),
                                    icon: SvgImages.close,
                                    onTap: () {
                                      context.read<UpdateStatusChatBloc>().add(
                                        Update(arguments: {
                                          "id": widget.data.id,
                                          "status": 3
                                        }),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            MoreButton(
                              title: getTranslated("report", context: context),
                              icon: SvgImages.report,
                              onTap: () {
                                CustomNavigator.pop();
                                CustomNavigator.push(Routes.addToReportPage, arguments: {
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
                                CustomNavigator.push(Routes.AddToBlockPage, arguments: {
                                  "user": widget.data.user,
                                  "isFromChat": true,
                                  "chatId": widget.data.id,
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.more_vert),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatBloc, AppState>(
                builder: (context, state) {
                  return _getMessageList();
                },
              ),
            ),
            if (widget.data.status != 2 && widget.data.status != 4)
              SafeArea(
                child: Column(
                  children: [
                    customImageIconSVG(
                        imageName: SvgImages.close,
                        height: 80,
                        color: Styles.ERORR_COLOR),
                    Text(
                      context.read<ChatsBloc>().getStatusMassage(
                          widget.data.status!,
                          widget.data.user?.nickname ?? "") ??
                          "",
                      style: AppTextStyles.w700
                          .copyWith(fontSize: 18, color: Styles.BLACK),
                    ),
                  ],
                ),
              ),
            if (widget.data.status == 2 || widget.data.status == 4)
              StreamBuilder<DatabaseEvent>(
                stream: ref
                    .child("messages")
                    .child(widget.data.id.toString())
                    .orderByKey()
                    .limitToLast(1)
                    .onValue,
                builder: (context, snapshot) {
                  final value = snapshot.data?.snapshot.value as Map?;
                  final lastMessageJson = value?.values.last as Map?;
                  final blockedBy = lastMessageJson?['blocked_by'];

                  if (blockedBy != null) {
                    return Column(
                      children: [
                        Icon(Icons.block, color: Colors.red, size: 60),
                        Text(
                          getTranslated("this_chat_is_blocked", context: context),
                          style: AppTextStyles.w700
                              .copyWith(fontSize: 18, color: Styles.BLACK),
                        ),
                      ],
                    );
                  }

                  return BlocBuilder<ChatBloc, AppState>(
                    builder: (context, state) {
                      return Visibility(
                        visible: state is! Loading,
                        child: Stack(
                          alignment: Alignment.topLeft,
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
                                          ),
                                        ),
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
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _getMessageList() {
    return FirebaseAnimatedList(
      controller: listScrollController,
      defaultChild: Center(child: CircularProgressIndicator()),
      query: ref
          .child("messages")
          .child(widget.data.id.toString())
          .limitToLast(_limit),
      itemBuilder: (context, snapshot, animation, index) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final message = MessageModel.fromJson(json);

        // ✅ Scroll only if it's the last message (i.e. new message received)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (listScrollController.hasClients &&
              index == _limit - 1) {
            listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        return MessageBubble(
          addDate: true,
          chat: message,
        );
      },
    );
  }

}

