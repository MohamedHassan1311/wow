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
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileGuardiandata extends StatefulWidget {
  final bool isEdit;
  final bool  scroll;

  const CompleteProfileGuardiandata({super.key,  this.scroll =true,this.isEdit=false});

  @override
  State<CompleteProfileGuardiandata> createState() =>
      _CompleteProfileBodyStpe1State();
}

class _CompleteProfileBodyStpe1State extends State<CompleteProfileGuardiandata>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CompleteProfileBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<CompleteProfileBloc>().formKey4,
          child: ListAnimator(
            scroll:widget. scroll,
            data: [
              ///Name
              CustomTextField(
                controller: context.read<CompleteProfileBloc>().gfName,
                label: "${getTranslated("First_name")} ${getTranslated("Guardian")}",
                hint:
                    "${getTranslated("enter")} ${getTranslated("First_name")} ${getTranslated("Guardian")}",
                inputType: TextInputType.name,
                pSvgIcon: SvgImages.user,
                validate: Validations.name,
              ),
              SizedBox(
                width: 10,
              ),
              CustomTextField(
                controller: context.read<CompleteProfileBloc>().glName,
                label: "${getTranslated("Second_name")} ${getTranslated("Guardian")}",
                hint:
                    "${getTranslated("enter")} ${getTranslated("Second_name")}",
                inputType: TextInputType.name,
                pSvgIcon: SvgImages.user,
                validate: Validations.name,
              ),

              BlocProvider(
                create: (context) =>
                SettingOptionBloc(repo: sl<SettingOptionRepo>())
                  ..add(Get(arguments:{'field_name': "grelation"} )),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                        state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream: context
                                .read<CompleteProfileBloc>()
                            .GrelationStream,
                            builder: (context, snapshot) {
                              return CustomDropDownButton(
                                label: getTranslated( "kinship"),
                                validation: (v) =>
                                    Validations.field(snapshot.data?.name),
                                value: null,
                                onChange: (v) {
                                  context
                                      .read<CompleteProfileBloc>()
                                      .updateGrelation(v as CustomFieldModel);
                                },
                                items: model.data ?? [],
                                name: context
                                    .read<CompleteProfileBloc>()
                                    .grelation
                                    .valueOrNull
                                    ?.name ??
                                    getTranslated("kinship"),
                              );
                            });
                      }
                      if (state is Loading) {
                        return CustomShimmerContainer(
                          height: 60.h,
                          width: context.width,
                          radius: 30,
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
              ),

              SizedBox(
                width: 10,
              ),
              CustomTextField(
                controller: context.read<CompleteProfileBloc>().otherGuardian,
                label: "${getTranslated("otherGuardian")}",
                hint:
                "${getTranslated("otherGuardian")}",
                inputType: TextInputType.name,
                pSvgIcon: SvgImages.user,
                validate: Validations.field,
              ),
              SizedBox(
                width: 10,
              ),
              CustomTextField(
                controller: context.read<CompleteProfileBloc>().gPhoneNumber,
                label: getTranslated("phone"),
                hint: getTranslated("enter_your_phone"),
                inputType: TextInputType.phone,
                align: Alignment.centerLeft,
                pSvgIcon: SvgImages.phone,
                prefixWidget: StreamBuilder<String?>(
                    stream: context
                        .read<CompleteProfileBloc>()
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
                                  snapshot.data ??
                                      countryCode?.code ??
                                      "",
                                  height: 25,
                                  width: 25,
                                  shape: const RoundedRectangle(100),
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
                            context
                                .read<CompleteProfileBloc>()
                                .updatePhoneCode(code!.code);
                          },
                          useUiOverlay: false,
                          useSafeArea: false);
                    }),

                validate:Validations.phone,

              ),

              Text(getTranslated("kinship_note"),

                maxLines: 3,
                style: const TextStyle(
                fontWeight: FontWeight.w300,

                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: Styles.HEADER,
              ),)

            ],
          ),
        );
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
