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

class HealthAndLifestyle extends StatefulWidget {
  const HealthAndLifestyle({super.key});

  @override
  State<HealthAndLifestyle> createState() => _HealthAndLifestyleState();
}

class _HealthAndLifestyleState extends State<HealthAndLifestyle>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomExpansionTile(
              initiallyExpanded: false,
              backgroundColor: Styles.WHITE_COLOR,
              title: getTranslated("health_and_lifestyle"),
              children: [
                StreamBuilder<CustomFieldModel?>(
                  stream: context.read<FilterBloc>().healthStream,
                  builder: (context, snapshot) {
                    final selectedHealth = snapshot.data;

                    return BlocProvider(
                      create: (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "health"})),
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
                                  label: getTranslated("health"),
                                  onCancel: () => CustomNavigator.pop(),
                                  onConfirm: () => CustomNavigator.pop(),
                                  widget: ListView(
                                    shrinkWrap: true,
                                    children: model.data!.map((item) {
                                      final isSelected = selectedHealth == item;

                                      return ListTile(
                                        title: Text(item.name ?? ""),
                                        trailing: isSelected
                                            ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                                            : Icon(Icons.radio_button_unchecked),
                                        onTap: ()  {
                                          context.read<FilterBloc>().updateHealth(
                                            isSelected ? null : item,
                                          );
                                          CustomNavigator.pop();
                                        },
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                              controller: TextEditingController(
                                text: selectedHealth?.name ?? "",
                              ),
                              label: getTranslated("health"),
                              hint: getTranslated("health"),
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
                  stream: context.read<FilterBloc>().lifestyleStream,
                  builder: (context, snapshot) {
                    final selectedLifestyle = snapshot.data;

                    return BlocProvider(
                      create: (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "lifestyle"})),
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
                                  label: getTranslated("lifestyle"),
                                  onCancel: () => CustomNavigator.pop(),
                                  onConfirm: () => CustomNavigator.pop(),
                                  widget: ListView(
                                    shrinkWrap: true,
                                    children: model.data!.map((item) {
                                      final isSelected = selectedLifestyle == item;

                                      return RadioListTile<CustomFieldModel>(
                                        value: item,
                                        groupValue: selectedLifestyle,
                                        title: Text(item.name??""),
                                        activeColor: Styles.PRIMARY_COLOR,
                                        onChanged: (value) {
                                          context.read<FilterBloc>().updateLifestyle(
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
                                text: selectedLifestyle?.name ?? "",
                              ),
                              label: getTranslated("lifestyle"),
                              hint: getTranslated("lifestyle"),
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
