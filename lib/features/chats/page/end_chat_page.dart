import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_drop_down_button.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_text_form_field.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/block/repo/block_repo.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/features/setting_option/bloc/setting_option_bloc.dart';
import 'package:wow/features/setting_option/repo/setting_option_repo.dart';
import 'package:wow/main_models/custom_field_model.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/person_card.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/main_app_bar.dart';
import '../bloc/update_status_chat_bloc.dart';
import '../model/chats_model.dart';
import '../repo/chats_repo.dart';

class EndChatPage extends StatefulWidget {
  final ChatModel chatModel;

  const EndChatPage({super.key, required this.chatModel});

  @override
  State<EndChatPage> createState() => _EndChatPageState();
}

class _EndChatPageState extends State<EndChatPage>
    with AutomaticKeepAliveClientMixin<EndChatPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(getTranslated("end_chat", context: context)),
      ),
      body: BlocProvider(
        create: (context) => UpdateStatusChatBloc(repo: sl<ChatsRepo>()),
        child: BlocBuilder<UpdateStatusChatBloc, AppState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),

                  Center(
                    child: Icon(
                      Icons.chat,
                      color: Styles.PRIMARY_COLOR,
                      size: 90.w,
                    ),
                  ),
                  SizedBox(height: 30.h),

                  Text(
                    getTranslated("end_chat_with", context: context)
                        .replaceAll("#", widget.chatModel.user?.nickname ?? ""),
                    style: AppTextStyles.w800.copyWith(
                      fontSize: 16.0,
                      color: Styles.HEADER,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  SizedBox(height: 10.h),
                  if (widget.chatModel.status != 1)
                    Text(
                      getTranslated("end_chat_des", context: context),
                      style: AppTextStyles.w500.copyWith(
                        fontSize: 16.0,
                        color: Styles.HEADER,
                      ),
                    ),

                  if (widget.chatModel.status != 1)
                    CustomTextField(
                      controller:
                          context.read<UpdateStatusChatBloc>().reasonController,
                      label: getTranslated("reason"),
                      hint:
                          "${getTranslated("enter")} ${getTranslated("reason")}",
                      inputType: TextInputType.text,
                      pSvgIcon: SvgImages.user,
                    ),

                  // Spacer(),
                  CustomButton(
                    text: getTranslated("end_chat"),
                    isLoading: state is Loading,
                    onTap: () {
                      context.read<UpdateStatusChatBloc>().add(
                            Update(arguments: {
                              "id": widget.chatModel.id,
                              "status": 3
                            }),
                          );
                    },
                  ),

                  Spacer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
