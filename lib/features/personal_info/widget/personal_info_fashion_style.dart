import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/components/animated_widget.dart';
import '../../../main_blocs/user_bloc.dart';

import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/svg_images.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/personal_profile_bloc.dart';

class PersonalInfoFashionStyle extends StatefulWidget {
  final bool isEdit;
  const PersonalInfoFashionStyle({super.key, this.isEdit = false});

  @override
  State<PersonalInfoFashionStyle> createState() =>
      _PersonalInfoFashionStyleState();
}

class _PersonalInfoFashionStyleState extends State<PersonalInfoFashionStyle>
    with AutomaticKeepAliveClientMixin {
  BuildContext? cityBlocContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<PersonalInfoBloc>().formKey5,
          child: ListAnimator(
            data: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  /// hijab
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "account_type"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                            state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream: context
                                .read<PersonalInfoBloc>()
                                .accountTypeStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CustomDropDownButton(
                                  label: getTranslated("class"),

                                  value: model.data!.firstWhereOrNull(
                                        (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled: widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.sect==null:true,
                                  onChange: (v) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateAccountType(
                                            v as CustomFieldModel);
                                  },
                                  items: model.data ?? [],
                                  name: context
                                          .read<PersonalInfoBloc>()
                                          .accountType
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("class"),
                                );
                              }
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

                  /// hijab
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "hijab"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                            state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream:
                                context.read<PersonalInfoBloc>().hijabStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CustomDropDownButton(
                                  label: getTranslated("hijab"),

                                  value:  model.data!.firstWhereOrNull(
                                        (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled: widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.sect==null:true,
                                  onChange: (v) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateHijab(v as CustomFieldModel);
                                  },
                                  items: model.data ?? [],
                                  name: context
                                          .read<PersonalInfoBloc>()
                                          .hijab
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("hijab"),
                                );
                              }
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

                  /// abaya
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "abaya"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                            state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream:
                                context.read<PersonalInfoBloc>().abayaStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CustomDropDownButton(
                                  label: getTranslated("abya"),
                                  // validation: (v) =>
                                  //     Validations.field(snapshot.data?.name),
                                  value:  model.data!.firstWhereOrNull(
                                        (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled:widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.tribe!=null:true,
                                  onChange: (v) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateTribe(v as CustomFieldModel);
                                  },
                                  items: model.data ?? [],
                                  name: context
                                          .read<PersonalInfoBloc>()
                                          .tribe
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("abya"),
                                );
                              }
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

                  /// culture
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "culture"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                            state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream:
                                context.read<PersonalInfoBloc>().cultureStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CustomDropDownButton(
                                  label: getTranslated("culture"),
                                  // validation: (v) =>
                                  //     Validations.field(snapshot.data?.name),
                                  value: model.data!.firstWhereOrNull(
                                        (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled:widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.tribe!=null:true,
                                  onChange: (v) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateCulture(v as CustomFieldModel);
                                  },
                                  items: model.data ?? [],
                                  name: context
                                          .read<PersonalInfoBloc>()
                                          .culture
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("culture"),
                                );
                              }
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

                  /// health
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "health"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                            state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream:
                                context.read<PersonalInfoBloc>().healthStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CustomDropDownButton(
                                  label: getTranslated("health"),
                                  // validation: (v) =>
                                  //     Validations.field(snapshot.data?.name),
                                  value:  model.data!.firstWhereOrNull(
                                        (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled:widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.tribe!=null:true,
                                  onChange: (v) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateHealth(v as CustomFieldModel);
                                  },
                                  items: model.data ?? [],
                                  name: context
                                          .read<PersonalInfoBloc>()
                                          .health
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("health"),
                                );
                              }
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

                  /// health
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "lifestyle"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model =
                            state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream: context
                                .read<PersonalInfoBloc>()
                                .lifestyleStream,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                return CustomDropDownButton(
                                  label: getTranslated("lifestyle"),
                                  // validation: (v) =>
                                  //     Validations.field(snapshot.data?.name),
                                  value: model.data!.firstWhereOrNull(
                                    (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled:widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.tribe!=null:true,
                                  onChange: (v) {
                                    context
                                        .read<PersonalInfoBloc>()
                                        .updateLifestyle(v as CustomFieldModel);
                                  },
                                  items: model.data ?? [],
                                  name: context
                                          .read<PersonalInfoBloc>()
                                          .lifestyle
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("lifestyle"),
                                );
                              }
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
                ],
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
