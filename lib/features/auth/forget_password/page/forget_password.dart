import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/features/auth/forget_password/bloc/forget_password_bloc.dart';
import 'package:wow/features/auth/forget_password/repo/forget_password_repo.dart';
import '../../../../app/core/app_event.dart';
import '../../../../app/core/app_state.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/animated_widget.dart';
import '../../../../components/back_icon.dart';
import '../../../../components/custom_button.dart';
import '../../../../components/custom_images.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../data/config/di.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';
import '../../verification/model/verification_model.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordBloc(repo: sl<ForgetPasswordRepo>()),
      child: BlocBuilder<ForgetPasswordBloc, AppState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListAnimator(
                          customPadding: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                              vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                          data: [
                            Center(
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                      Dimensions.PADDING_SIZE_DEFAULT.h),
                                  child: Image.asset(
                                       Images.splash,
                                      width: 130.w,
                                      height: 130.h)),
                            ),
                            Text(
                              getTranslated("forget_password_header"),
                              style: AppTextStyles.w700.copyWith(
                                fontSize: 24,
                                color: Styles.HEADER,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 4.h),
                              child: Text(
                                getTranslated("forget_password_title"),
                                style: AppTextStyles.w600.copyWith(
                                    fontSize: 20, color: Styles.TITLE),
                              ),
                            ),
                            Text(
                              getTranslated("forget_password_description"),
                              style: AppTextStyles.w500.copyWith(
                                  fontSize: 16, color: Styles.DETAILS_COLOR),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL.h),
                            Form(
                                key: context
                                    .read<ForgetPasswordBloc>()
                                    .formKey,
                                child: Column(
                                  children: [
                                    ///Mail
                                    StreamBuilder<String?>(
                                        stream: context
                                            .read<ForgetPasswordBloc>()
                                            .emailStream,
                                        builder: (context, snapshot) {
                                          return CustomTextField(
                                            autofillHints: const [
                                              AutofillHints.email,
                                              AutofillHints.username,
                                            ],
                                            onChanged: context
                                                .read<ForgetPasswordBloc>()
                                                .updateEmail,
                                            focusNode: context
                                                .read<ForgetPasswordBloc>()
                                                .emailNode,
                                            label: getTranslated("mail"),
                                            hint: getTranslated(
                                                "enter_your_mail"),
                                            inputType:
                                            TextInputType.emailAddress,
                                            pSvgIcon: SvgImages.mail,
                                            validate: (v) {
                                              if ((v) != null) {
                                                context
                                                    .read<
                                                    ForgetPasswordBloc>()
                                                    .email
                                                    .addError(
                                                    Validations.mail(v) ??
                                                        "");
                                              }
                                              return null;
                                            },
                                            errorText: snapshot.error,
                                            customError: snapshot.hasError,
                                          );
                                        }),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: Text(
                                        getTranslated(
                                            "forget_password_description"),
                                        style: AppTextStyles.w500.copyWith(
                                            fontSize: 12,
                                            color: Styles.DETAILS_COLOR),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                          vertical: Dimensions.paddingSizeMini.h,
                        ),
                        child: CustomButton(
                            text: getTranslated("send_code"),
                            onTap: () {
                              context
                                  .read<ForgetPasswordBloc>()
                                  .formKey
                                  .currentState!
                                  .validate();
                              if (Validations.mail(context
                                  .read<ForgetPasswordBloc>()
                                  .email
                                  .valueOrNull) ==
                                  null) {
                                // CustomNavigator.push(Routes.verification,
                                //     arguments: VerificationModel(
                                //         email: context
                                //             .read<ForgetPasswordBloc>()
                                //             .email
                                //             .valueOrNull,
                                //         fromRegister: false));
                                context.read<ForgetPasswordBloc>().add(Click());
                              }
                            },
                            isLoading: state is Loading),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                        vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilteredBackIcon(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
