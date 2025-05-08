import 'dart:io';
import 'package:country_flags/country_flags.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/components/animated_widget.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../main_widgets/profile_image_widget.dart';
import '../../../components/custom_expansion_tile.dart';
import '../../../data/config/di.dart';
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
                    spacing: 15,
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
                                  withEdit: false,
                                  imageFile: snapshot.data,
                                  onGet: context
                                      .read<EditProfileBloc>()
                                      .updateProfileImage);
                            }),
                      ),
                      Text(
                        UserBloc.instance.user?.name??"",
                        style: AppTextStyles.w800
                            .copyWith(fontSize: 16, color:  Styles.HEADER),
                      ),

                      CustomExpansionTile(
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                InkWell(
                                    onTap: (){
                                      CustomNavigator.push(Routes.CompleteProfile);
                                    },
                                    child: Text(getTranslated("edit"))),

                                Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                          title: getTranslated("Basic data"), children: [
                        BlocProvider(
                          create: (context) => CompleteProfileBloc(
                              repo: sl<CompleteProfileRepo>())..onInit(),
                          child: BlocBuilder<CompleteProfileBloc, AppState>(
                            builder: (context, state) {

                                return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  CompleteProfileHeader(),
                                  CompleteProfileNameAndGender(scroll: false,),
                                  CompleteProfileNationalityAndCountry(isAdd: false,isView: true,),
                                  CompleteProfileMaritalStatus(isAdd: false,isView: true,),
                                 if( UserBloc.instance.user!.gender!="M")
                                  CompleteProfileGuardiandata(scroll: false,),
                                  CompleteProfileVerification(isAdd: false,isView: true,)
                                ],
                              );


                            },
                          ),
                        )
                      ]),

                      CustomExpansionTile(
                          trailing: SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                InkWell(
                                    onTap: (){
                                      CustomNavigator.push(Routes.personalInfo);
                                    },
                                    child: Text(getTranslated("edit"))),

                                Icon(Icons.arrow_drop_down_rounded),
                              ],
                            ),
                          ),
                          title: getTranslated("Secondary data"), children: [
                        BlocProvider(
                          create: (context) => PersonalInfoBloc(repo: sl<PersonalInfoRepo>()),
                          child: BlocBuilder<PersonalInfoBloc, AppState>(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  PersonalInfoHeader(),
                                  PersonalInfoEducation(),
                                  PersonalInfoJob(),
                                  PersonalInfoShape(),
                                  PersonalInfoSectAndTribe(),
                                  PersonalProfileIntroduction(scroll: false,)

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
