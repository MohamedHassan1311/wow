import 'package:country_codes/country_codes.dart';
import 'package:country_flags/country_flags.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/features/auth/register/enitity/register_entity.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_app_bar.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../../main_models/custom_field_model.dart';
import '../../../countries/view/country_selection.dart';
import '../bloc/register_bloc.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, AppState>(
      builder: (context, state) {
        return StreamBuilder<RegisterEntity?>(
            stream: context.read<RegisterBloc>().registerEntityStream,
            initialData: RegisterEntity(
              name: TextEditingController(),
              email: TextEditingController(),
              phone: TextEditingController(),
              password: TextEditingController(),
              country: "+966",
              confirmPassword: TextEditingController(),
            ),
            builder: (context, snapshotReg) {
              return Form(
                  key: context.read<RegisterBloc>().formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [




                      ///Mail
                      CustomTextField(
                        controller: snapshotReg.data?.email,
                        focusNode: context.read<RegisterBloc>().emailNode,
                        nextFocus: context.read<RegisterBloc>().phoneNode,
                        label: getTranslated("mail"),
                        hint: getTranslated("enter_your_mail"),
                        inputType: TextInputType.emailAddress,
                        pSvgIcon: SvgImages.mail,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshotReg.data?.copyWith(
                                  emailError: Validations.mail(v) ?? ""));
                          return null;
                        },
                        errorText: snapshotReg.data?.emailError,
                        customError: snapshotReg.data?.emailError != null &&
                            snapshotReg.data?.emailError != "",
                      ),

                      ///Phone
                      CustomTextField(
                        controller: snapshotReg.data?.phone,
                        label: getTranslated("phone"),
                        hint: getTranslated("enter_your_phone"),
                        inputType: TextInputType.phone,
                        align: Alignment.centerLeft,
                        pSvgIcon: SvgImages.phone,

                        sufWidget:StreamBuilder<String?>(
                            stream: context
                                .read<RegisterBloc>()
                                .phoneCodeStream,
                            builder: (context, snapshot) {
                              return CountryListPick(

                                  appBar: CustomAppBar(
                                      title:
                                      getTranslated("select_your_country")),
                                  pickerBuilder:
                                      (context, CountryCode? countryCode) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CountryFlag.fromCountryCode(
                                          "SA",
                                          height: 18,
                                          width: 18,
                                          shape: const RoundedRectangle(1),
                                        ),
                                        SizedBox(width: 6.w),
                                        Text(
                                          CountryCodes.detailsForLocale(
                                            Locale.fromSubtags(
                                                countryCode:
                                                snapshot.data ??
                                                    countryCode?.code ??
                                                    "SA"),
                                          ).dialCode ??
                                              "+966",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: AppTextStyles.w400.copyWith(
                                              fontSize: 14,
                                              height: 1,
                                              color: Styles.HEADER),
                                        ),
                                      ],
                                    );
                                  },
                                  theme: CountryTheme(
                                    labelColor: Styles.ACCENT_COLOR,
                                    alphabetSelectedBackgroundColor:
                                    Styles.ACCENT_COLOR,
                                    isShowFlag: true,
                                    isShowTitle: true,
                                    isShowCode: false,
                                    isDownIcon: true,
                                    showEnglishName: true,
                                  ),
                                  initialSelection: snapshot.data ?? "SA",
                                  onChanged: (CountryCode? code) {
                                    snapshotReg.data?.country=code!.code;
                                    context
                                        .read<RegisterBloc>()
                                        .updatePhoneCode(code!.code);
                                  },
                                  useUiOverlay: false,
                                  useSafeArea: false);
                            }),
                        focusNode: context.read<RegisterBloc>().phoneNode,
                        nextFocus: context.read<RegisterBloc>().countryNode,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshotReg.data?.copyWith(
                                  phoneError: Validations.phone(v) ?? ""));
                          return null;
                        },
                        errorText: snapshotReg.data?.phoneError,
                        customError: snapshotReg.data?.phoneError != null &&
                            snapshotReg.data?.phoneError != "",
                      ),

                      ///Country
                      // CountrySelection(
                      //   initialSelection: snapshot.data?.country,
                      //   onSelect: (v) {
                      //     context.read<RegisterBloc>().updateRegisterEntity(
                      //         snapshot.data?.copyWith(country: v));
                      //   },
                      //   focusNode: context.read<RegisterBloc>().countryNode,
                      //   nextFocus: context.read<RegisterBloc>().passwordNode,
                      //   validate: (v) {
                      //     context.read<RegisterBloc>().updateRegisterEntity(
                      //         snapshot.data?.copyWith(
                      //             countryError: Validations.field(
                      //                     snapshot.data?.country?.name,
                      //                     fieldName:
                      //                         getTranslated("country")) ??
                      //                 ""));
                      //     return null;
                      //   },
                      //   error: snapshot.data?.countryError,
                      //   haseError: snapshot.data?.countryError != null &&
                      //       snapshot.data?.countryError != "",
                      // ),

                      ///Password
                      CustomTextField(
                        controller: snapshotReg.data?.password,
                        label: getTranslated("password"),
                        hint: getTranslated("enter_your_password"),
                        focusNode: context.read<RegisterBloc>().passwordNode,
                        nextFocus:
                            context.read<RegisterBloc>().confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshotReg.data?.copyWith(
                                  passwordError:
                                      Validations.firstPassword(v) ?? ""));
                          return null;
                        },
                        errorText: snapshotReg.data?.passwordError,
                        customError: snapshotReg.data?.passwordError != null &&
                            snapshotReg.data?.passwordError != "",
                      ),

                      ///Confirm Password
                      CustomTextField(
                        controller: snapshotReg.data?.confirmPassword,
                        label: getTranslated("confirm_password"),
                        hint: getTranslated("enter_confirm_password"),
                        focusNode: context.read<RegisterBloc>().confirmPasswordNode,
                        inputType: TextInputType.visiblePassword,
                        isPassword: true,
                        pSvgIcon: SvgImages.lockIcon,
                        validate: (v) {
                          context.read<RegisterBloc>().updateRegisterEntity(
                              snapshotReg.data?.copyWith(
                                  confirmPasswordError:
                                      Validations.confirmNewPassword(
                                          snapshotReg.data?.password?.text.trim(), v) ??
                                          ""));
                          return null;
                        },
                        errorText: snapshotReg.data?.confirmPasswordError,
                        customError: snapshotReg.data?.confirmPasswordError != null && snapshotReg.data?.confirmPasswordError != "",
                        keyboardAction: TextInputAction.done,
                      ),
                    ],
                  ));
            });
      },
    );
  }
}
