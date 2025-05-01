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
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../../main_widgets/identity_verification_image_widget.dart';
import '../../../main_widgets/profile_image_widget.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileVerification extends StatefulWidget {
  const CompleteProfileVerification({super.key});

  @override
  State<CompleteProfileVerification> createState() =>
      _CompleteProfileBodyStpe1State();
}

class _CompleteProfileBodyStpe1State extends State<CompleteProfileVerification>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CompleteProfileBloc, AppState>(
      builder: (context, state) {
        return Form(
            key: context.read<CompleteProfileBloc>().formKey5,
            child:  ListAnimator(
              data: [
                Center(
                  child: Text(getTranslated("verification_des"),

                    maxLines: 3,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,

                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Styles.HEADER,
                    ),),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                  ),
                  child: StreamBuilder<File?>(
                      stream: context
                          .read<CompleteProfileBloc>()
                          .identityImageeStream,
                      builder: (context, snapshot) {
                        return IdentityVerificationWidget(
                            withEdit: true,
                            imageFile: snapshot.data,
                            onGet: context
                                .read<CompleteProfileBloc>()
                                .updateIdentityImage);
                      }),
                ),
                Text(getTranslated("verification_note"),

                  maxLines: 3,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,

                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: Styles.HEADER,
                  ),)
              ],
            ));
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
