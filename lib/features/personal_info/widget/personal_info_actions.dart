import 'dart:developer';

import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/extensions.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../data/config/di.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';

import '../../../app/core/images.dart';
import '../../../components/custom_alert_dialog.dart';
import '../../complete_profile/widget/submit_confirmation_dialog.dart';
import '../../language/bloc/language_bloc.dart';
import '../bloc/personal_profile_bloc.dart';


class PersonalInfoActions extends StatefulWidget {
  const PersonalInfoActions({super.key});

  @override
  State<PersonalInfoActions> createState() => _PersonalInfoActionsState();
}

class _PersonalInfoActionsState extends State<PersonalInfoActions>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder<int?>(
            stream: context.read<PersonalInfoBloc>().currentStepStream,
            builder: (context, snapshot) {
              return Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
                    child: Row(
                      spacing: 25,
                      children: [
                        if (snapshot.data != 1)
                          Expanded(
                            child: CustomButton(
                                text: getTranslated("previous"),
                                backgroundColor: Colors.transparent,
                                textColor: Styles.PRIMARY_COLOR,
                                borderColor: Styles.PRIMARY_COLOR,
                                withBorderColor: true,
                                onTap: () {
                                  if (snapshot.data! > 1) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateCurrentStep(snapshot.data! - 1);

                                    context
                                        .read<PersonalInfoBloc>()
                                        .pageController
                                        .jumpToPage(snapshot.data! - 2);
                                  }
                                },
                                ),
                          ),
                        Expanded(
                          child: Center(
                            child: CustomButton(
                                text: getTranslated("next"),
                                onTap: () async {
                            print(snapshot.data!);
                                  if (snapshot.data! < 6) {
                                    if (snapshot.data! == 1) {
                                      if (!context
                                          .read<PersonalInfoBloc>()
                                          .formKey1
                                          .currentState!
                                          .validate()) return;
                                    }

                                    if (snapshot.data! == 2) {
                                      if (!context
                                          .read<PersonalInfoBloc>()
                                          .formKey2
                                          .currentState!
                                          .validate()) return;
                                    }
                                    if (snapshot.data! == 3) {
                                      if (!context
                                          .read<PersonalInfoBloc>()
                                          .formKey3
                                          .currentState!
                                          .validate()) return;
                                    }
                                    if (snapshot.data! == 4) {
                                      if (!context
                                          .read<PersonalInfoBloc>()
                                          .formKey4
                                          .currentState!
                                          .validate()) return;
                                    }

                                    print(snapshot.data!);
                                    if (snapshot.data! == 5) {

                                      final result=await    CustomAlertDialog.show(
                                          dailog: AlertDialog(
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical:
                                                  Dimensions.PADDING_SIZE_DEFAULT.w,
                                                  horizontal:
                                                  Dimensions.PADDING_SIZE_DEFAULT.w),
                                              insetPadding: EdgeInsets.symmetric(
                                                  vertical:
                                                  Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                                                  horizontal: context.width * 0.1),
                                              shape: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.transparent),
                                                  borderRadius:
                                                  BorderRadius.circular(20.0)),
                                              content:SubmitConfirmationDialog()
                                          ));
                                      if(result) {
                                        context.read<PersonalInfoBloc>().add(
                                        Click(),
                                      );
                                      }
                                      return;
                                    }

                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateCurrentStep(snapshot.data! + 1);
                                    context
                                        .read<PersonalInfoBloc>()
                                        .pageController
                                        .jumpToPage(snapshot.data!);
                                  } else {

                                  }
                                },
                                isLoading: state is Loading),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              );
            });
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class _AgreeToTerms extends StatelessWidget {
  const _AgreeToTerms({
    this.check = true,
    required this.onChange,
  });
  final bool check;
  final Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 12.h, 8.w, 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            onTap: () => onChange(!check),
            child: Icon(
              check ? Icons.check_box : Icons.check_box_outline_blank,
              color: check ? Styles.PRIMARY_COLOR : Styles.DISABLED,
              size: 22,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                  text: "${getTranslated("by_signing_in_you_agree")}\n",
                  style: AppTextStyles.w500
                      .copyWith(fontSize: 14, color: Styles.TITLE),
                  children: [
                    TextSpan(
                        text: getTranslated("terms_conditions"),
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 14,
                            color: Styles.PRIMARY_COLOR,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            CustomNavigator.push(Routes.terms);
                          }),
                    TextSpan(
                      text: " & ",
                      style: AppTextStyles.w500
                          .copyWith(fontSize: 14, color: Styles.TITLE),
                    ),
                    TextSpan(
                        text: getTranslated("privacy_policy"),
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 14,
                            color: Styles.PRIMARY_COLOR,
                            decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            CustomNavigator.push(Routes.privacy);
                          }),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}
