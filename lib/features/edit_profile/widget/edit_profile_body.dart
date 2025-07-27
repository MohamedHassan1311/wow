import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/features/complete_profile/widget/complete_profile_actions.dart';
import 'package:wow/features/personal_info/widget/personal_info_actions.dart';
import 'package:wow/features/plans/model/plans_model.dart';
import 'package:wow/features/plans/widgets/paln_card.dart';

import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../main_widgets/profile_image_widget.dart';
import '../../../app/core/app_event.dart';
import '../../../components/custom_expansion_tile.dart';
import '../../../data/config/di.dart';
import '../../../helpers/remote_config_service.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../complete_profile/bloc/complete_profile_bloc.dart';
import '../../complete_profile/repo/complete_profile_repo.dart';
import '../../complete_profile/widget/complete_profile_guardian_data.dart';
import '../../complete_profile/widget/complete_profile_header.dart';
import '../../complete_profile/widget/complete_profile_marital_status.dart';
import '../../complete_profile/widget/complete_profile_name_and_gender.dart';
import '../../complete_profile/widget/complete_profile_nationality_and_country.dart';
import '../../complete_profile/widget/complete_profile_verification.dart';
import '../../personal_info/bloc/personal_profile_bloc.dart';
import '../../personal_info/repo/perosnal_info_repo.dart';
import '../../personal_info/widget/persona_info_education.dart';
import '../../personal_info/widget/personal_info_header.dart';
import '../../personal_info/widget/personal_info_inteoduaction.dart';
import '../../personal_info/widget/personal_info_job.dart';
import '../../personal_info/widget/personal_info_sect_and_tribe.dart';
import '../../personal_info/widget/personal_info_shape.dart';
import '../bloc/edit_profile_bloc.dart';

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({super.key, required this.fromComplete});
  final bool fromComplete;

  @override
  State<EditProfileBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<EditProfileBody> {
  final FocusNode nameNode = FocusNode();
  final FocusNode emailNode = FocusNode();
  final FocusNode phoneNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<EditProfileBloc, AppState>(
        builder: (context, state) {
          return ListAnimator(
            customPadding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
            data: [
              Form(
                  key: context.read<EditProfileBloc>().formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ///Image Profile
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        ),
                        child: StreamBuilder<File?>(
                            stream: context
                                .read<EditProfileBloc>()
                                .profileImageStream,
                            builder: (context, snapshot) {
                              return ProfileImageWidget(
                                  withEdit: true,
                                  imageFile: snapshot.data,
                                  onGet: (v){
                                    context
                                        .read<EditProfileBloc>()
                                        .updateProfileImage(v);
                                    context
                                        .read<EditProfileBloc>().add(Click());
                                  });
                            }),
                      ),
                      Text(
                        UserBloc.instance.user?.nickname ?? "",
                        style: AppTextStyles.w800
                            .copyWith(fontSize: 28, color: Styles.HEADER),
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      if(AppConfig.isIosFlag)

                      Container(
                        width: context.width,
                        decoration: BoxDecoration(
                          color: Styles.SMOKED_WHITE_COLOR,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 10,
                          children: [
                            // Row(
                            //   spacing: 10,
                            //   children: [
                            //     Text(
                            //       getTranslated("remaining_favourit"),
                            //       style: AppTextStyles.w700.copyWith(
                            //           fontSize: 20,
                            //           color: Styles.PRIMARY_COLOR),
                            //     ),
                            //     Text(
                            //       UserBloc.instance.user?.number_of_likes
                            //               .toString() ??
                            //           "0",
                            //       style: AppTextStyles.w400.copyWith(
                            //           fontSize: 20, color: Styles.BLACK),
                            //     ),
                            //   ],
                            // ),
                            Row(
                              spacing: 10,
                              children: [
                                Text(
                                  getTranslated("remaining_likes"),
                                  style: AppTextStyles.w500.copyWith(
                                      fontSize: 18,
                                      color: Styles.PRIMARY_COLOR),
                                ),
                                Text(
                                  UserBloc.instance.user?.number_of_interst
                                          .toString() ??
                                      "0",
                                  style: AppTextStyles.w400.copyWith(
                                      fontSize: 18, color: Styles.BLACK),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              children: [
                                Text(
                                  getTranslated("remaining_chats"),
                                  style: AppTextStyles.w500.copyWith(
                                      fontSize: 18,
                                      color: Styles.PRIMARY_COLOR),
                                ),
                                Text(
                                  UserBloc.instance.user?.number_of_chats
                                          .toString() ??
                                      "0",
                                  style: AppTextStyles.w400.copyWith(
                                      fontSize: 18, color: Styles.BLACK),
                                ),
                              ],
                            ),
                            // Text(
                            //   getTranslated("unlimited_start"),
                            //   style: AppTextStyles.w400
                            //       .copyWith(fontSize: 18, color: Styles.BLACK),
                            // ),
                            CustomButton(
                                width: context.width * 0.2,
                                height: 40,
                                text: getTranslated("Upgrade"),
                                onTap: () {
                                  CustomNavigator.push(Routes.plans);
                                }),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(
                        getTranslated("welcomeMessage") ?? "",
                        style: AppTextStyles.w400
                            .copyWith(color: Styles.HEADER, fontSize: 13),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      CustomExpansionTile(
                          initiallyExpanded: false,
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      CustomNavigator.push(
                                          Routes.CompleteProfile,
                                          arguments: true);
                                    },
                                    child: Text(getTranslated("edit"))),
                                Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                          title: getTranslated("Basic data"),
                          children: [
                            BlocProvider(
                              create: (context) => CompleteProfileBloc(
                                  repo: sl<CompleteProfileRepo>())
                                ..onInit(),
                              child: BlocBuilder<CompleteProfileBloc, AppState>(
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      CompleteProfileHeader(),
                                      CompleteProfileNameAndGender(
                                          scroll: false, isEdit: true),

                                      CompleteProfileNationalityAndCountry(
                                          isScroll: false,
                                          isView: true,
                                          isEdit: true),
                                      CompleteProfileMaritalStatus(
                                          isAdd: false,
                                          isView: true,
                                          isEdit: true),
                                      if (UserBloc.instance.user!.gender != "M")
                                        CompleteProfileGuardiandata(
                                            scroll: false, isEdit: true),
                                      if(UserBloc.instance.user?.nationalityId?.code?.toLowerCase() == "sa")
                                      CompleteProfileVerification(
                                          isAdd: false,
                                          isView: true,
                                          isEdit: true),
                                      // CompleteProfileActions(
                                      //     isEdit: true, isView: true),
                                    ],
                                  );
                                },
                              ),
                            )
                          ]),

                      SizedBox(
                        height: 10,
                      ),

                      CustomExpansionTile(
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                    onTap: () {
                                      CustomNavigator.push(Routes.personalInfo,
                                          arguments: true);
                                    },
                                    child: Text(getTranslated("edit"))),
                                Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                          title: getTranslated("Secondary data"),
                          children: [
                            BlocProvider(
                              create: (context) =>
                                  PersonalInfoBloc(repo: sl<PersonalInfoRepo>())
                                    ..onInit(),
                              child: BlocBuilder<PersonalInfoBloc, AppState>(
                                builder: (context, state) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 10,
                                    children: [
                                      PersonalInfoHeader(),
                                      PersonalInfoEducation(isEdit: true,isScroll: false,),
                                      PersonalInfoJob(isEdit: true,isScroll: false,),
                                      PersonalInfoShape(isEdit: true,isScroll: false,),
                                      PersonalInfoSectAndTribe(isEdit: true,isScroll: false,),
                                      PersonalProfileIntroduction(
                                        scroll: false,
                                      ),
                                      // PersonalInfoActions(
                                      //     isEdit: true, fromViewProfile: true),
                                    ],
                                  );
                                },
                              ),
                            )
                          ]),
                    ],
                  )),
            ],
          );
        },
      ),
    );
  }
}
