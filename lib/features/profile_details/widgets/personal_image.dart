import 'package:flutter/material.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/back_icon.dart';
import 'package:wow/components/custom_alert_dialog.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/chats/bloc/start_chat_bloc.dart';
import 'package:wow/features/chats/repo/chats_repo.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/features/marige_request/bloc/marige_request_bloc.dart';
import 'package:wow/features/profile_details/widgets/maridge_request_dialog.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';

import '../../../navigation/routes.dart';

class PersonalImage extends StatefulWidget {
  final UserModel user;
  const PersonalImage({super.key, required this.user});

  @override
  State<PersonalImage> createState() => _PersonalImageState();
}

class _PersonalImageState extends State<PersonalImage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomNetworkImage.containerNewWorkImage(
          image: widget.user.image ?? "",
          radius: 25,
          width: context.width,
          height: context.height * .45,
          defaultImage: "assets/images/imagebg.png",
          fit: BoxFit.cover,
        ),
        Positioned(
            top: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilteredBackIcon(),
            )),
        Positioned(
            bottom: 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    onTap: () {
                      if (widget.user.isFavourit == 0) {
                        sl<FavouritBloc>().add(Add(arguments: widget.user.id));

                        setState(() {
                          widget.user.isFavourit = 1;
                        });
                      } else {
                        sl<FavouritBloc>()
                            .add(Delete(arguments: widget.user.id));
                        setState(() {
                          widget.user.isFavourit = 0;
                        });
                      }
                    },
                    imageName: widget.user.isFavourit == 0
                        ? SvgImages.star
                        : SvgImages.starFill,
                    color: Styles.WHITE_COLOR,
                    width: 40.w,
                    height: 40.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                  ),
                ),

                /// chat
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    onTap: () async {
                      final result = await CustomAlertDialog.show(
                          dailog: AlertDialog(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                                  horizontal:
                                      Dimensions.PADDING_SIZE_DEFAULT.w),
                              insetPadding: EdgeInsets.symmetric(
                                  vertical:
                                      Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                                  horizontal: context.width * 0.1),
                              shape: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                  borderRadius: BorderRadius.circular(20.0)),
                              content: MaridgeRequestDialog(
                                name: getTranslated("chat_request_desc").replaceAll(
                                    "#",
                                    " ${UserBloc.instance.user!.number_of_chats}"),
                                discription:
                                    getTranslated("chat_request_desc_2")
                                        .replaceAll(
                                            "#", " ${widget.user.nickname!}"),
                                image: SvgImages.chats,
                              )));
                      if (result == true) {
                        StartChatBloc(repo: sl<ChatsRepo>())
                            .add(Send(arguments: widget.user.id));
                      }
                    },
                    imageName: SvgImages.chats,
                    color: Styles.WHITE_COLOR,
                    width: 40.w,
                    height: 40.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                  ),
                ),

                /// Maridge Request
                if (widget.user.gender == "F")
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customContainerSvgIcon(
                      onTap: () async {
                        final result = await CustomAlertDialog.show(
                            dailog: AlertDialog(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                insetPadding: EdgeInsets.symmetric(
                                    vertical:
                                        Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                                    horizontal: context.width * 0.1),
                                shape: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                    borderRadius: BorderRadius.circular(20.0)),
                                content: MaridgeRequestDialog(
                                  showTextFeild: true,
                                  name: getTranslated("marige_request"),
                                  discription:
                                      getTranslated("marige_request_desc")
                                          .replaceAll(
                                              "#", " " + widget.user.nickname!),
                                  image: SvgImages.ring,
                                )));
                        if (result is bool && result == true) {
                          sl<MarigeRequestBloc>().add(Send(arguments: {
                            'id': widget.user.id,
                            "message": ""
                          }));
                        }
                        if (result is String && result.isNotEmpty) {
                          sl<MarigeRequestBloc>().add(Send(arguments: {
                            'id': widget.user.id,
                            "message": result
                          }));
                        }
                      },
                      imageName: SvgImages.ring,
                      color: Styles.WHITE_COLOR,
                      width: 40.w,
                      height: 40.w,
                      padding: 10.w,
                      radius: 26.w,
                      borderColor: Styles.WHITE_COLOR,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    color: Styles.WHITE_COLOR,
                    width: 40.w,
                    height: 40.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                    onTap: () {
                      CustomNavigator.push(Routes.addToReportPage, arguments: {
                        "user": widget.user,
                        "isFromChat": false
                      });
                    },
                    imageName: SvgImages.report,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customContainerSvgIcon(
                    color: Styles.WHITE_COLOR,
                    width: 40.w,
                    height: 40.w,
                    padding: 10.w,
                    radius: 26.w,
                    borderColor: Styles.WHITE_COLOR,
                    onTap: () async {
                      CustomNavigator.push(Routes.AddToBlockPage, arguments: {
                        "user": widget.user,
                        "isFromChat": false
                      });
                    },
                    imageName: SvgImages.block,
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
