import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/features/chat/model/message_model.dart';
import 'package:wow/features/chat/repo/chat_repo.dart';
import 'package:wow/features/chats/bloc/chats_bloc.dart';
import 'package:wow/features/chats/bloc/update_status_chat_bloc.dart';
import 'package:wow/features/chats/repo/chats_repo.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_network_image.dart';
import '../../../data/config/di.dart';
import '../bloc/delete_chat_bloc.dart';
import '../model/chats_model.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.chat});
  final ChatModel chat;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteChatBloc(repo: sl<ChatsRepo>()),
      child: BlocBuilder<DeleteChatBloc, AppState>(
        builder: (context, state) {
          return Slidable(
            key: UniqueKey(),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              extentRatio: 0.2,
              children: [
                SlidableAction(
                  onPressed: (context) => context
                      .read<DeleteChatBloc>()
                      .add(Delete(arguments: chat.id)),
                  backgroundColor: Styles.RED_COLOR,
                  foregroundColor: Colors.white,
                  icon: Icons.delete_outline,
                ),
              ],
            ),
            child: InkWell(
              onTap: () => CustomNavigator.push(
                Routes.chat,
                arguments: chat,
              ),
              child: Container(
                width: context.width,
                padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                ),
                decoration: const BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Styles.BORDER_COLOR))),
                child: Row(
                  children: [
                    CustomNetworkImage.circleNewWorkImage(
                        color: Styles.HINT_COLOR,
                        image: chat.user?.image ?? "",
                        radius: 35),
                    SizedBox(width: 12.w),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              chat.user?.nickname ?? "Name",
                              style: AppTextStyles.w600.copyWith(
                                  fontSize: 16, color: Styles.ACCENT_COLOR),
                            ),
                            Spacer(),
                            Flexible(
                              child: Text(
                                chat.createdAt?.dateFormat(
                                        format: 'd MMM yyyy  hh,mm aa') ??
                                    DateTime.now().dateFormat(format: "h:m"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.w400.copyWith(
                                    fontSize: 12, color: Styles.DETAILS_COLOR),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        SizedBox(height: 10.h),
                        Text(
                          context.read<ChatsBloc>().getStatusMassage(
                                  chat.status!, chat.user?.nickname ?? "") ??
                              "",
                          style: AppTextStyles.w700
                              .copyWith(fontSize: 12, color: Styles.BLACK),
                        ),
                        if (chat.status == 1) SizedBox(height: 10.h),
                        if (chat.status == 1&& chat.senderId != UserBloc.instance.user!.id)
                          SizedBox(
                            height: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: BlocProvider(
                                    create: (context) => UpdateStatusChatBloc(
                                        repo: sl<ChatsRepo>()),
                                    child: BlocBuilder<UpdateStatusChatBloc,
                                        AppState>(builder: (context, state) {
                                      return CustomButton(
                                        radius: 60,
                                        text: getTranslated("accept") ,
                                        isLoading: state is Loading,
                                        onTap: () {
                                          context
                                              .read<UpdateStatusChatBloc>()
                                              .add(Update(arguments: {
                                                "id": chat.id,
                                                "status": 4
                                              }));
                                        },
                                      );
                                    }),
                                  ),
                                ),
                                Expanded(
                                    child: BlocProvider(
                                  create: (context) => UpdateStatusChatBloc(
                                      repo: sl<ChatsRepo>()),
                                  child: BlocBuilder<UpdateStatusChatBloc,
                                      AppState>(builder: (context, state) {
                                    return CustomButton(
                                      radius: 60,
                                      backgroundColor: Styles.GREY_BORDER,
                                      textColor: Styles.BLACK,
                                      isLoading: state is Loading,
                                      text: getTranslated("reject"),
                                      onTap: () {
                                        context
                                            .read<UpdateStatusChatBloc>()
                                            .add(Update(arguments: {
                                              "id": chat.id,
                                              "status": 5
                                            }));
                                      },
                                    );
                                  }),
                                ))
                              ],
                            ),
                          ),
                      ],
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  messageOption(MessageItem message) {
    switch (MessageType.values[message.type ?? 0]) {
      case MessageType.text:
        return Text(
          chat.message?.message ?? "message",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.w400
              .copyWith(fontSize: 12, color: Styles.DETAILS_COLOR),
        );
      case MessageType.image:
        return const Icon(
          Icons.image,
          size: 18,
          color: Styles.HINT_COLOR,
        );
      case MessageType.audio:
        return const Icon(
          Icons.audiotrack,
          size: 18,
          color: Styles.HINT_COLOR,
        );
      case MessageType.video:
        return const Icon(
          Icons.video_collection_rounded,
          size: 18,
          color: Styles.HINT_COLOR,
        );

      case MessageType.file:
        return customImageIconSVG(
            imageName: SvgImages.file,
            color: Styles.HINT_COLOR,
            width: 14,
            height: 14);
      case MessageType.invitation:
        return const SizedBox();
    }
  }
}
