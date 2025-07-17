import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';
import 'package:wow/features/marige_request/bloc/marige_request_bloc.dart';
import 'package:wow/features/marige_request/model/mairdege_model.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/profile_image_widget.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class MaridgeReqCard extends StatefulWidget {
  final ProposalData? user;
  MaridgeReqCard({
    super.key,
    this.user,
  });

  @override
  State<MaridgeReqCard> createState() => _MaridgeReqCardState();
}

class _MaridgeReqCardState extends State<MaridgeReqCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CustomNavigator.push(Routes.profileDetails, arguments: widget.user?.clientId);
      },
      child: Container(
        width: context.width,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              customContainerSvgIcon(
                imageName: SvgImages.ring,
                color: Styles.BLACK,
                backGround: Colors.transparent,
                width: 80.w,
                height: 80.w,
                padding: 10.w,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      getTranslated("you_have_a_marige_request", context: context, ).replaceAll("#", widget.user?.nickname ?? "Mohamed"),
                      maxLines: 2,
                      textAlign:TextAlign.center ,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.w600.copyWith(
                        color: Styles.BLACK,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),
                  if (widget.user?.isVerified == 1)
                    customImageIconSVG(
                      imageName: SvgImages.verify,
                      width: 20,
                      height: 20,
                    ),
                ],
              ),

/// Pending and user gender is female
              if (widget.user?.proposalStatus == 1 && UserBloc.instance.user?.gender == "F")
              Row(
                spacing: 15,
                children: [
                  Expanded(
                    child: CustomButton(
                      width: 80,
                      height: 45,
                      textSize: 14,
                      onTap: () {
                        context.read<MarigeRequestBloc>().add(Accept(arguments: widget.user?.id));
                      },
                      text: getTranslated("accept", context: context),
                      // color: Styles.PRIMARY_COLOR,
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      width: 80,
                      height: 45,
                      backgroundColor: Styles.GREY_BORDER,
                      borderColor: Styles.GREY_BORDER,
                      textColor: Styles.BLACK,
                      textSize: 14,
                      onTap: () {
                        context.read<MarigeRequestBloc>().add(Reject(arguments: widget.user?.id));
                      },
                      text: getTranslated("reject", context: context),
                      // color: Styles.PRIMARY_COLOR,
                    ),
                  ),
                ],
              ),





     /// Pending and user gender is male
            if (widget.user?.proposalStatus != 1 )
            Text(getTranslated(widget.user?.proposalStatus.proposalStatusText ?? "Unknown", context: context), style: AppTextStyles.w600.copyWith(color: Styles.BLACK, fontSize: 18),)


    ,
            /// Pending and user gender is male
            if (widget.user?.proposalStatus == 1 && UserBloc.instance.user?.gender == "M")
            Row(
              spacing: 15,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               CustomButton(
                      width: 80,
                      height: 45,
                        backgroundColor: Styles.RED_COLOR,
                        borderColor: Styles.RED_COLOR,
                        textColor: Styles.WHITE_COLOR,
                      textSize: 14,
                      onTap: () {
                        context.read<MarigeRequestBloc>().add(Reject(arguments: widget.user?.id));
                      },
                      text: getTranslated("cancel", context: context),
                      // color: Styles.PRIMARY_COLOR,
                    ),
              ],
            ),



            ],
          ),
        ),
      ),
    );
  }
}
