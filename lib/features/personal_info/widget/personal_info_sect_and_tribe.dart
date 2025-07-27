import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';
import '../../../components/animated_widget.dart';
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

class PersonalInfoSectAndTribe extends StatefulWidget {
  final bool isEdit;

  final bool isScroll;
  const PersonalInfoSectAndTribe({super.key, this.isEdit = false,  this.isScroll=true});

  @override
  State<PersonalInfoSectAndTribe> createState() =>
      _PersonalInfoSectAndTribeState();
}

class _PersonalInfoSectAndTribeState extends State<PersonalInfoSectAndTribe>
    with AutomaticKeepAliveClientMixin {
  BuildContext? cityBlocContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<PersonalInfoBloc>().formKey4,
          child: ListAnimator(
            scroll: widget.isScroll,
            data: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [

                  /// other nationality
                  BlocProvider(
                    create: (context) =>
                        SettingOptionBloc(repo: sl<SettingOptionRepo>())
                          ..add(Get(arguments: {'field_name': "religion"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                      if (state is Done) {
                        CustomFieldsModel model = state.model as CustomFieldsModel;

                        return StreamBuilder<CustomFieldModel?>(
                            stream: context
                                .read<PersonalInfoBloc>()
                                .SectStream,
                            builder: (context, snapshot) {
                              if(snapshot.data!=null){
                              return CustomDropDownButton(
                                label: getTranslated("Sect"),

                                  value:  model.data!.firstWhereOrNull(
                                        (v) => v.id == snapshot.data?.id,
                                  ),
                                  // isEnabled: widget.isEdit? snapshot.data!=null&& UserBloc.instance.user?.validation?.sect==null:true,
                                onChange: (v) {
                                  context
                                      .read<PersonalInfoBloc>()
                                      .updateSect(
                                          v as CustomFieldModel);
                                },
                                items: model.data ?? [],
                                name: context
                                        .read<PersonalInfoBloc>()
                                        .Sect
                                        .valueOrNull
                                        ?.name ??
                                    getTranslated("Sect"),
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


                  /// tribe
                  BlocProvider(
                    create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "tribe"})),
                    child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                          if (state is Done) {
                            CustomFieldsModel model = state.model as CustomFieldsModel;

                            return StreamBuilder<CustomFieldModel?>(
                                stream:
                                context.read<PersonalInfoBloc>().tribeStream,

                                builder: (context, snapshot) {
                                  if(snapshot.data!=null){
                                  return CustomDropDownButton(
                                    label: getTranslated("tribe"),
                                    // validation: (v) =>
                                    //     Validations.field(snapshot.data?.name),
                        value: model.data!.firstWhereOrNull(
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
                                        getTranslated("tribe"),
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


                  CustomTextField(
                    controller:
                    context.read<PersonalInfoBloc>().otherTribe,
                    label: getTranslated("other_tribe"),
                    // isEnabled:widget.isEdit? context.read<PersonalInfoBloc>().otherTribe.text.isNotEmpty&& UserBloc.instance.user?.validation?.tribe!=null:true,
                    hint:
                    "${getTranslated("enter")} ${getTranslated("other_tribe")}",
                    inputType: TextInputType.name,
                    pSvgIcon: SvgImages.user,
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
