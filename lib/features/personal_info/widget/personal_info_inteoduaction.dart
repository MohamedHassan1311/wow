import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';

import 'package:wow/features/complete_profile/widget/select_gender.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/animated_widget.dart';

import '../../../main_widgets/identity_verification_image_widget.dart';
import '../../../main_widgets/profile_image_widget.dart';
import '../bloc/personal_profile_bloc.dart';

class PersonalProfileIntroduction extends StatefulWidget {
  final bool isEdit;
  final bool scroll;

  const PersonalProfileIntroduction(
      {super.key, this.scroll = true, this.isEdit = false});

  @override
  State<PersonalProfileIntroduction> createState() =>
      _CompleteProfileBodyStpe1State();
}

class _CompleteProfileBodyStpe1State extends State<PersonalProfileIntroduction>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return Form(
            key: context.read<PersonalInfoBloc>().formKey5,
            child: ListAnimator(
              scroll: widget.scroll,
              data: [
                if (widget.scroll)
                  Center(
                    child: Text(
                      getTranslated("profile_image"),
                      maxLines: 3,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Styles.HEADER,
                      ),
                    ),
                  ),
                if (widget.scroll)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                      ),
                      child: StreamBuilder<File?>(
                          stream: context
                              .read<PersonalInfoBloc>()
                              .identityImageeStream,
                          builder: (context, snapshot) {
                            return ProfileImageWidget(
                                withEdit: true,
                                imageFile: snapshot.data,
                                onGet: context
                                    .read<PersonalInfoBloc>()
                                    .updateIdentityImage);
                          }),
                    ),
                  ),
                if (widget.scroll)
                  Text(
                    getTranslated("profile_image_note"),
                    maxLines: 3,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Styles.HEADER,
                    ),
                  ),
                CustomTextField(
                  controller: context.read<PersonalInfoBloc>().personalInfo,
                  label: getTranslated("personal_info"),
                  hint:
                      "${getTranslated("enter")} ${getTranslated("personal_info")}",
                  inputType: TextInputType.name,
                  pSvgIcon: SvgImages.user,
                  maxLines: 6,
                  validate: Validations.name,
                ),
                CustomTextField(
                  controller: context.read<PersonalInfoBloc>().partenrInfo,
                  label: getTranslated("partnerInfo"),
                  maxLines: 6,
                  hint:
                      "${getTranslated("enter")} ${getTranslated("partnerInfo")}",
                  inputType: TextInputType.name,
                  pSvgIcon: SvgImages.user,
                  validate: Validations.name,
                ),
              ],
            ));
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
