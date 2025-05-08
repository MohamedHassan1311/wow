import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileNationalityAndCountry extends StatefulWidget {
  final bool isScroll;
  final bool isView;

  const CompleteProfileNationalityAndCountry(
      {super.key, this.isScroll = true, this.isView = false});

  @override
  State<CompleteProfileNationalityAndCountry> createState() =>
      _CompleteProfileNationalityAndCountryState();
}

class _CompleteProfileNationalityAndCountryState
    extends State<CompleteProfileNationalityAndCountry>
    with AutomaticKeepAliveClientMixin {
  BuildContext? cityBlocContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CompleteProfileBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<CompleteProfileBloc>().formKey2,
          child: ListAnimator(
            scroll: widget.isScroll,
            data: [
              /// nationality
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "country"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<CustomFieldModel?>(
                        stream: context
                            .read<CompleteProfileBloc>()
                            .nationalityStream,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return CustomDropDownButton(
                              label: getTranslated("nationality"),
                              validation: (v) =>
                                  Validations.field(snapshot.data?.name),
                              value: model.data?.firstWhere(
                                (v) => v.id == snapshot.data?.id,
                                orElse: () => CustomFieldModel(name: "no_data"),
                              ),
                              isEnabled: !widget.isView,
                              items: model.data ?? [],
                              onChange: (v) {
                                context
                                    .read<CompleteProfileBloc>()
                                    .updateNationality(v as CustomFieldModel);
                              },
                              name: context
                                      .read<CompleteProfileBloc>()
                                      .nationality
                                      .valueOrNull
                                      ?.name ??
                                  getTranslated("nationality"),
                            );
                          } else
                            return SizedBox();
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
                height: 10,
              ),

              /// other nationality
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "country"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<CustomFieldModel?>(
                        stream: context
                            .read<CompleteProfileBloc>()
                            .otherNationalityStream,
                        builder: (context, snapshot) {
                          if (snapshot.data != null)
                          return CustomDropDownButton(
                            isEnabled: !widget.isView,
                            label: getTranslated("other_nationality"),
                            value: model.data?.firstWhere(
                              (v) => v.id == snapshot.data?.id,
                              orElse: () => CustomFieldModel(name: "no_data"),
                            ),
                            onChange: (v) {
                              context
                                  .read<CompleteProfileBloc>()
                                  .updateOtherNationality(
                                      v as CustomFieldModel);
                            },
                            items: model.data ?? [],
                            name: context
                                    .read<CompleteProfileBloc>()
                                    .otherNationality
                                    .valueOrNull
                                    ?.name ??
                                getTranslated("other_nationality"),
                          );

                          return SizedBox();
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
                height: 10,
              ),

              /// other nationality
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "country"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<CustomFieldModel?>(
                        stream: context
                            .read<CompleteProfileBloc>()
                            .countryOfResidence,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            return Column(
                            spacing: 12,
                            children: [

                              CustomDropDownButton(
                                label: getTranslated("Country_of_Residence"),
                                isEnabled: !widget.isView,
                                validation: (v) =>
                                    Validations.field(snapshot.data?.name),
                                value: model.data?.firstWhere(
                                  (v) => v.id == snapshot.data?.id,
                                  orElse: () =>
                                      CustomFieldModel(name: "no_data"),
                                ),
                                onChange: (v) {
                                  context
                                      .read<CompleteProfileBloc>()
                                      .updateCountryOfResidence(
                                          v as CustomFieldModel);
                                  cityBlocContext
                                      ?.read<SettingOptionBloc>()
                                      .add(Get(arguments: {
                                        'field_name': "city",
                                        "country_id": context
                                            .read<CompleteProfileBloc>()
                                            .countryOfResidence
                                            .valueOrNull!
                                            .id
                                      }));
                                },
                                items: model.data ?? [],
                                name: context
                                        .read<CompleteProfileBloc>()
                                        .countryOfResidence
                                        .valueOrNull
                                        ?.name ??
                                    getTranslated("Country_of_Residence"),
                              ),

                              /// City
                              Visibility(
                                visible: context
                                        .read<CompleteProfileBloc>()
                                        .countryOfResidence
                                        .valueOrNull !=
                                    null,
                                child: BlocProvider(
                                  create: (context) => SettingOptionBloc(
                                      repo: sl<SettingOptionRepo>())
                                    ..add(Get(arguments: {
                                      'field_name': "city",
                                      "country_id": context
                                          .read<CompleteProfileBloc>()
                                          .countryOfResidence
                                          .valueOrNull!
                                          .id
                                    })),
                                  child:
                                      BlocBuilder<SettingOptionBloc, AppState>(
                                          builder: (context, state) {
                                    cityBlocContext = context;
                                    if (state is Done) {
                                      CustomFieldsModel model =
                                          state.model as CustomFieldsModel;

                                      return StreamBuilder<CustomFieldModel?>(
                                          stream: context
                                              .read<CompleteProfileBloc>()
                                              .cityStream,
                                          builder: (context, snapshot) {
                                            if(snapshot.data!=null) {
                                              return CustomDropDownButton(
                                              label: getTranslated("city"),
                                              validation: (v) =>
                                                  Validations.field(
                                                      snapshot.data?.name),
                                              value: model.data?.firstWhere(
                                                (v) =>
                                                    v.id == snapshot.data?.id,
                                                orElse: () => CustomFieldModel(
                                                    name: "no_data"),
                                              ),
                                              isEnabled: widget.isScroll,
                                              onChange: (v) {
                                                context
                                                    .read<CompleteProfileBloc>()
                                                    .updateCity(
                                                        v as CustomFieldModel);
                                              },
                                              items: model.data ?? [],
                                              name: context
                                                      .read<
                                                          CompleteProfileBloc>()
                                                      .city
                                                      .valueOrNull
                                                      ?.name ??
                                                  getTranslated(
                                                      "Country_of_Residence"),
                                            );
                                            }else return SizedBox();
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
                              ),
                            ],
                          );
                          } else return SizedBox();
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
