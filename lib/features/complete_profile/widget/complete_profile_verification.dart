import 'dart:io';

import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';

import 'package:wow/features/complete_profile/widget/select_gender.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';

import '../../../components/animated_widget.dart';

import '../../../main_widgets/identity_verification_image_widget.dart';

import '../bloc/complete_profile_bloc.dart';

class CompleteProfileVerification extends StatefulWidget {
  final bool isAdd;
  final bool isView;
  final bool isEdit;
  const CompleteProfileVerification({super.key,  this.isAdd=true,this.isView = false,this.isEdit=false});

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
              scroll:widget. isAdd,
              data: [
                Center(
                  child: Column(
                    children: [
                      Text(getTranslated("verification_des"),

                        maxLines: 3,
                        style: const TextStyle(
                          fontWeight: FontWeight.w300,

                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Styles.HEADER,
                        ),),
                      if(UserBloc.instance.user?.validation?.identityFile!=null)
                      Container(
                        decoration: BoxDecoration(
                            color: Styles.ERORR_COLOR.withOpacity(.10),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              UserBloc.instance.user?.validation?.identityFile?? "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                overflow: TextOverflow.ellipsis,
                                color: Styles.ERORR_COLOR,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
                            image: UserBloc.instance.user?.identityFile,
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
