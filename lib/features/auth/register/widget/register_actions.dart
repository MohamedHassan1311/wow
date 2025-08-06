import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/core/app_event.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../data/config/di.dart';
import '../../../../helpers/remote_config_service.dart';
import '../../../../helpers/social_media_login_helper.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../../language/bloc/language_bloc.dart';
import '../../../setting/bloc/setting_bloc.dart';
import '../../social_media_login/bloc/social_media_bloc.dart';
import '../../social_media_login/repo/social_media_repo.dart';
import '../../verification/model/verification_model.dart';
import '../bloc/register_bloc.dart';

class RegisterActions extends StatelessWidget {
  const RegisterActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, AppState>(
      builder: (context, state) {
        return Column(
          children: [
            StreamBuilder<bool?>(
                stream: context.read<RegisterBloc>().agreeToTermsStream,
                builder: (context, snapshot) {
                  return _AgreeToTerms(
                    check: snapshot.data ?? false,
                    onChange: context.read<RegisterBloc>().updateAgreeToTerms,
                  );
                }),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: CustomButton(
                  text: getTranslated("signup"),
                  rIconWidget: RotatedBox(
                    quarterTurns: sl<LanguageBloc>().isLtr ? 0 : 2,
                    child: customImageIconSVG(
                      imageName: SvgImages.forwardArrow,
                      color: Styles.WHITE_COLOR,
                    ),
                  ),
                  onTap: () {
                    print(context
                        .read<RegisterBloc>()
                        .formKey
                        .currentState!
                        .validate());

                    if (context
                        .read<RegisterBloc>()
                        .formKey
                        .currentState!
                        .validate()) {
                      context.read<RegisterBloc>().add(Click());
                    }
                  },
                  isLoading: state is Loading),
            ),

            ///Login up if u have account

            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: getTranslated("have_acc"),
                  style: AppTextStyles.w400
                      .copyWith(fontSize: 14, color: Styles.DETAILS_COLOR),
                  children: [
                    TextSpan(
                        text: " ${getTranslated("sign_in")}",
                        style: AppTextStyles.w600.copyWith(
                          fontSize: 16,
                          color: Styles.PRIMARY_COLOR,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => CustomNavigator.pop()),
                  ]),
            ),
            SizedBox(height: 12.h),
            if(AppConfig.isIosFlag)

              Visibility(
                visible: context.read<SettingBloc>().nationality.value?.toUpperCase()!="SA",
                child: Wrap(
                  runSpacing: 16.w,
                  spacing: 16.h,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ///Login With Google
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_SMALL.h),
                      child: BlocProvider(
                        create: (context) =>
                            SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                        child: BlocBuilder<SocialMediaBloc, AppState>(
                          builder: (context, state) {
                            if (state is Loading)
                              return CupertinoActivityIndicator();
                            return customImageIconSVG(
                              imageName: SvgImages.google,
                              width: 40.w,
                              height: 40.w,
                              onTap: () {
                                context.read<SocialMediaBloc>().add(
                                  Click(
                                    arguments:
                                    SocialMediaProvider.google,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),

                    if (Platform.isIOS)
                      BlocProvider(
                        create: (context) =>
                            SocialMediaBloc(repo: sl<SocialMediaRepo>()),
                        child: BlocBuilder<SocialMediaBloc, AppState>(
                          builder: (context, state) {
                            if (state is Loading)
                              return CupertinoActivityIndicator();
                            return customImageIconSVG(
                              imageName: SvgImages.apple,
                              width: 40.w,
                              height: 40.w,
                              onTap: () {
                                context.read<SocialMediaBloc>().add(
                                  Click(
                                    arguments:
                                    SocialMediaProvider.apple,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              )
          ],
        );
      },
    );
  }
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
