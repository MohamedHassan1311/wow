import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/core/app_storage_keys.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../components/custom_network_image.dart';
import '../../../../data/config/di.dart';

import '../../model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel chat;
  final bool addDate;
  MessageBubble({super.key, required this.chat, required this.addDate});
  SharedPreferences sharedPreferences = sl.get<SharedPreferences>();
  @override
  Widget build(BuildContext context) {
    final myId = sharedPreferences.getString(AppStorageKey.userId).toString();
    bool isMe = chat.type == "patient";

    String dateTime = (chat.date).dateTimeFormatChat();

    return Column(
      crossAxisAlignment:
          !isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isMe
              ? EdgeInsets.fromLTRB(50, 5, 10, 5)
              : EdgeInsets.fromLTRB(10, 5, 50, 5),
          child: Column(
            crossAxisAlignment:
                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          bottomLeft:
                              isMe ? Radius.circular(15) : Radius.circular(0),
                          bottomRight:
                              isMe ? Radius.circular(0) : Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        color: isMe
                            ? Styles.PRIMARY_COLOR.withOpacity(.2)
                            : Styles.APP_BAR_BACKGROUND_COLOR,
                      ),
                      child: Column(
                        crossAxisAlignment: !isMe
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if(chat.photo!.isNotEmpty)
                          CustomNetworkImage.containerNewWorkImage(
                              image: chat.photo ?? "",
                              width: 200.h,
                              height: 200.h,


                              radius: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE,
                                vertical: Dimensions.PADDING_SIZE_SMALL/2),
                            child: SelectableText( chat.massage ,
                                style: TextStyle(
                                    fontSize: 16,
                                    color:  Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color)),
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_LARGE/2,
                                vertical: Dimensions.PADDING_SIZE_SMALL/4),
                            child: Text(dateTime,
                                style: TextStyle(
                                  fontSize: 10, )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 1),

            ],
          ),
        ),
      ],
    );
  }
}
