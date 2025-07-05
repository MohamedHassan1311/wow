import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_expansion_tile.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/fillter/bloc/filtter_bloc.dart';
import 'package:wow/features/fillter/widget/custom_selete.dart';
import 'package:wow/features/setting_option/bloc/setting_option_bloc.dart';
import 'package:wow/features/setting_option/repo/setting_option_repo.dart';
import 'package:wow/main_models/custom_field_model.dart';

import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../navigation/custom_navigation.dart';

class FashionStyle extends StatefulWidget {
  const FashionStyle({super.key});

  @override
  State<FashionStyle> createState() => _FashionStyleState();
}

class _FashionStyleState extends State<FashionStyle>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: ListAnimator(
        scroll: false,
        data: [
          CustomExpansionTile(
              backgroundColor: Styles.WHITE_COLOR,
              initiallyExpanded: false,
              title: getTranslated("fashion_style"),
              children: [
                StreamBuilder<CustomFieldModel?>(
                  stream: context.read<FilterBloc>().hijabStream,
                  builder: (context, snapshot) {
                    final selectedHijab = snapshot.data;

                    return BlocProvider(
                      create: context.read<FilterBloc>().hijab.value?.id == null
                          ? (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "hijab"}))
                          : (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>()),
                      child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                          if (state is Loading) {
                            return CustomShimmerContainer(
                              height: 60.h,
                              width: context.width,
                              radius: 30,
                            );
                          } else if (state is Done) {
                            final model = state.model as CustomFieldsModel;

                            return CustomTextField(
                              readOnly: true,
                              sufWidget: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Styles.ACCENT_COLOR,
                              ),
                              onTap: () {
                                CustomBottomSheet.show(
                                  label: getTranslated("hijab"),
                                  onCancel: () => CustomNavigator.pop(),
                                  onConfirm: () => CustomNavigator.pop(),
                                  widget: ListView(
                                    shrinkWrap: true,
                                    children: model.data!.map((item) {
                                      final isSelected = selectedHijab == item;

                                      return RadioListTile<CustomFieldModel>(
                                        value: item,
                                        groupValue: selectedHijab,
                                        title: Text(item.name??""),
                                        activeColor: Styles.PRIMARY_COLOR,
                                        onChanged: (value) {
                                          context.read<FilterBloc>().updateHijab(
                                            isSelected ? null : value,
                                          );
                                          CustomNavigator.pop();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                              controller: TextEditingController(
                                text: selectedHijab?.name ?? "",
                              ),
                              label: getTranslated("hijab"),
                              hint: getTranslated("hijab"),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    );
                  },
                ),

                StreamBuilder<CustomFieldModel?>(
                  stream: context.read<FilterBloc>().abyaStream,
                  builder: (context, snapshot) {
                    final selectedAbya = snapshot.data;

                    return BlocProvider(
                      create: context.read<FilterBloc>().abya.value?.id == null
                          ? (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "abaya"}))
                          : (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>()),
                      child: BlocBuilder<SettingOptionBloc, AppState>(
                        builder: (context, state) {
                          if (state is Loading) {
                            return CustomShimmerContainer(
                              height: 60.h,
                              width: context.width,
                              radius: 30,
                            );
                          } else if (state is Done) {
                            final model = state.model as CustomFieldsModel;

                            return CustomTextField(
                              readOnly: true,
                              sufWidget: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Styles.ACCENT_COLOR,
                              ),
                              onTap: () {
                                CustomBottomSheet.show(
                                  label: getTranslated("abya"),
                                  onCancel: () => CustomNavigator.pop(),
                                  onConfirm: () => CustomNavigator.pop(),
                                  widget: ListView(
                                    shrinkWrap: true,
                                    children: model.data!.map((item) {
                                      final isSelected = selectedAbya == item;

                                      return RadioListTile<CustomFieldModel>(
                                        value: item,
                                        groupValue: selectedAbya,
                                        title: Text(item.name??""),
                                        activeColor: Styles.PRIMARY_COLOR,
                                        onChanged: (value) {
                                          context.read<FilterBloc>().updateAbya(
                                            isSelected ? null : value,
                                          );
                                          CustomNavigator.pop();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                              controller: TextEditingController(
                                text: selectedAbya?.name ?? "",
                              ),
                              label: getTranslated("abya"),
                              hint: getTranslated("abya"),
                            );
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                    );
                  },
                ),

              ]),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
