import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/features/chat/entity/typing_entity.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_network_image.dart';
import '../../../components/custom_text_form_field.dart';
import '../../chats/model/chats_model.dart';
import '../bloc/chat_bloc.dart';
import '../entity/message_entity.dart';
import '../repo/chat_repo.dart';
import 'buttons/image_button.dart';

class ChatBottomSheet extends StatefulWidget {
  const ChatBottomSheet({
    super.key,
    required this.chatId,
    required this.data,
  });
  final ChatModel data;
  final String chatId;

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  bool isExpand = false;
  Timer? timer;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MessageEntity>(
        stream: context.read<ChatBloc>().messageStream,
        initialData: MessageEntity(chatId: widget.chatId),
        builder: (context, messageSnapshot) {
          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
              vertical: Dimensions.PADDING_SIZE_DEFAULT.h / 3,
            ),
            decoration: const BoxDecoration(
              color: Styles.WHITE_COLOR,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: SafeArea(
              bottom: true,
              top: false,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StreamBuilder<TypingEntity?>(
                            stream: context.read<ChatBloc>().typingStream,
                            builder: (context, typingSnapshot) {
                              return CustomTextField(
                                hint: getTranslated("write_your_message"),
                                controller: context.read<ChatBloc>().controller,
                                maxLines: 3,
                                sufWidget: customImageIconSVG(
                                  imageName: SvgImages.attach,
                                  color: Styles.PRIMARY_COLOR,
                                  width: 20,
                                  height: 20,
                                  onTap: () {
                                    setState(() {
                                      isExpand = !isExpand;
                                    });
                                  },
                                ),
                                prefixWidget: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: CircleAvatar(
                                    backgroundColor: Styles.PRIMARY_COLOR,
                                    radius: 24.w,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: customImageIconSVG(
                                        imageName: SvgImages.send,
                                        color: Styles.WHITE_COLOR,
                                        onTap: () {
                                          if (context.read<ChatBloc>().controller.text.isNotEmpty ||
                                              (messageSnapshot.hasData &&
                                                  messageSnapshot.data !=
                                                      null &&
                                                  messageSnapshot
                                                          .data!.message !=
                                                      null)) {
                                            context
                                                .read<ChatBloc>()
                                                .add(SendMessage(arguments: {
                                                  "message":
                                                      context.read<ChatBloc>().controller.text.trim(),
                                                  "receiverId":
                                                      widget.data.doctorId,
                                                  "convId": widget.data.id,
                                                }));

                                            context.read<ChatBloc>().controller.clear();
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    crossFadeState: isExpand
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 250),
                    firstChild: Padding(
                      padding: EdgeInsets.only(
                          top: Dimensions.PADDING_SIZE_DEFAULT.h),
                      child: Row(
                        children: [
                          /*  AttachButton(
                            onSelectFile: (v) {
                              context.read<ChatBloc>().updateMessage(
                                    messageSnapshot.data!.copyWith(
                                        chatId: widget.chatId,
                                        message: v,
                                        messageType: MessageType.file),
                                  );
                              context.read<ChatBloc>().add(SendMessage());
                            },
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL.w),
                          VideoButton(
                            onSelectFile: (v) {
                              context.read<ChatBloc>().updateMessage(
                                    messageSnapshot.data!.copyWith(
                                        chatId: widget.chatId,
                                        message: v,
                                        messageType: MessageType.video),
                                  );
                              context.read<ChatBloc>().add(SendMessage());
                            },
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL.w),*/
                          ImageButton(
                            onSelectFile: (v) {
                              context.read<ChatBloc>().updateMessage(
                                    messageSnapshot.data!.copyWith(
                                        chatId: widget.chatId,
                                        message: v,
                                        messageType: MessageType.image),
                                  );
                            },
                          ),
                          if (messageSnapshot.hasData &&
                              messageSnapshot.data != null &&
                              messageSnapshot.data!.message != null)
                            Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child:
                                      CustomNetworkImage.containerNewWorkImage(
                                          image:
                                              messageSnapshot.data!.message ??
                                                  "",
                                          width: 100.h,
                                          height: 100.h,
                                          radius: 10),
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: IconButton(
                                        onPressed: () {
                                          context
                                              .read<ChatBloc>()
                                              .updateMessage(
                                                MessageEntity(),
                                              );
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline_rounded,
                                          color: Colors.red,
                                        ))),
                              ],
                            ),
                        ],
                      ),
                    ),
                    secondChild: const SizedBox(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
