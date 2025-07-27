import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/main_blocs/user_bloc.dart';

import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/svg_images.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/personal_profile_bloc.dart';

class PersonalInfoShape extends StatefulWidget {
  final bool isEdit;

  final bool isScroll;
  const PersonalInfoShape({super.key,this.isEdit=false,  this.isScroll=false});

  @override
  State<PersonalInfoShape> createState() =>
      _PersonalInfoShapeState();
}

class _PersonalInfoShapeState extends State<PersonalInfoShape>
    with AutomaticKeepAliveClientMixin {
  BuildContext? cityBlocContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<PersonalInfoBloc>().formKey3,
          child: ListAnimator(
            scroll: widget.isScroll,
            data: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [


                  CustomTextField(
                    controller:
                    context.read<PersonalInfoBloc>().height,
                    label: getTranslated("height"),
                    hint:
                    "${getTranslated("enter")} ${getTranslated("height")}",
                    inputType: TextInputType.number,
                    pSvgIcon: SvgImages.user,
                    // validate: Validations.field,
                    // isEnabled:widget.isEdit? context.read<PersonalInfoBloc>().height.text.isNotEmpty&& UserBloc.instance.user?.validation?.height!=null:true,
                  ),

                  CustomTextField(
                    controller:
                    context.read<PersonalInfoBloc>().weight,
                    label: getTranslated("weight"),
                    hint:
                    "${getTranslated("enter")} ${getTranslated("weight")}",
                    inputType: TextInputType.number,
                    pSvgIcon: SvgImages.user,
                    // validate: Validations.field,
                    // isEnabled:widget.isEdit? context.read<PersonalInfoBloc>().weight.text.isNotEmpty&& UserBloc.instance.user?.validation?.weight!=null:true,
                  ),
                  /// Shape
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "body_type"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model = state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream:
                                context.read<PersonalInfoBloc>().bodyTypeStream,
                            builder: (context, snapshot) {
                              if(snapshot.data!=null){
                              return CustomDropDownButton(
                                label: getTranslated("body_type"),
                                // validation: (v) =>
                                //     Validations.field(snapshot.data?.name),
                                value:  model.data!.firstWhereOrNull(
                                      (v) => v.id == snapshot.data?.id,
                                ),
                                // isEnabled :widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.bodyType!=null:true,
                                onChange: (v) {
                                  context
                                      .read<PersonalInfoBloc>()
                                      .updateBodyType(v as CustomFieldModel);
                                },
                                items: model.data ?? [],
                                name: context
                                        .read<PersonalInfoBloc>()
                                        .bodyType
                                        .valueOrNull
                                        ?.name ??
                                    getTranslated("body_type"),
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

                  /// skin_color
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "complexion"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model = state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream: context
                                .read<PersonalInfoBloc>()
                                .skinColorStream,
                            builder: (context, snapshot) {
                              if(snapshot.data!=null){
                              return CustomDropDownButton(
                                label: getTranslated("skin_color"),
                                value:  model.data!.firstWhereOrNull(
                                      (v) => v.id == snapshot.data?.id,
                                ),
                                // isEnabled:widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.skinColor!=null:true,
                                onChange: (v) {
                                  context
                                      .read<PersonalInfoBloc>()
                                      .updateSkinColor(
                                          v as CustomFieldModel);
                                },
                                items: model.data ?? [],
                                name: context
                                        .read<PersonalInfoBloc>()
                                        .skinColor
                                        .valueOrNull
                                        ?.name ??
                                    getTranslated("skin_color"),
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
