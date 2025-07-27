import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/components/custom_expansion_tile.dart';
import 'package:wow/features/fillter/widget/custom_selete.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../app/core/app_event.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../../navigation/custom_navigation.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/filtter_bloc.dart';

class SocialStatusAndClassleGuardianData extends StatefulWidget {
  final bool isEdit;
  final bool scroll;

  const SocialStatusAndClassleGuardianData(
      {super.key, this.scroll = true, this.isEdit = false});

  @override
  State<SocialStatusAndClassleGuardianData> createState() =>
      _CompleteProfileBodyStpe1State();
}

class _CompleteProfileBodyStpe1State
    extends State<SocialStatusAndClassleGuardianData>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<FilterBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<FilterBloc>().formKey4,
          child: ListAnimator(
            scroll: false,
            data: [
              CustomExpansionTile(
                  initiallyExpanded: true,
                  title: getTranslated("social_status_and_class"),
                  backgroundColor: Styles.WHITE_COLOR,
                  children: [
                    StreamBuilder<CustomFieldModel?>(
                      stream: context.read<FilterBloc>().socialStatusStream,
                      builder: (context, snapshot) {
                        final selectedStatus = snapshot.data;

                        return BlocProvider(
                          create: (context) => SettingOptionBloc(repo: sl<SettingOptionRepo>())
                            ..add(Get(arguments: {'field_name': "social_status"})),
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
                                      label: getTranslated("social_status"),
                                      onCancel: () => CustomNavigator.pop(),
                                      onConfirm: () => CustomNavigator.pop(),
                                      widget: ListView(
                                        shrinkWrap: true,
                                        children: model.data!.map((item) {
                                          final isSelected = selectedStatus == item;

                                          return ListTile(
                                            title: Text(item.name ?? ""),
                                            trailing: isSelected
                                                ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                                                : Icon(Icons.radio_button_unchecked),
                                            onTap: ()  {
                                              context.read<FilterBloc>().updateSocialStatus(
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
                                    text: selectedStatus?.name ?? "",
                                  ),
                                  label: getTranslated("social_status"),
                                  hint: getTranslated("social_status"),
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
                      stream: context.read<FilterBloc>().categoryStream,
                      builder: (context, snapshot) {
                        final selectedCategory = snapshot.data;

                        return BlocProvider(
                          create: (context) => SettingOptionBloc(
                            repo: sl<SettingOptionRepo>(),
                          )..add(Get(arguments: {'field_name': "account_type"})),
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
                                      label: getTranslated("class"),
                                      onCancel: () => CustomNavigator.pop(),
                                      onConfirm: () => CustomNavigator.pop(),
                                      widget: ListView(
                                        shrinkWrap: true,
                                        children: model.data!.map((item) {
                                          final isSelected = selectedCategory == item;

                                          return ListTile(
                                            title: Text(item.name ?? ""),
                                            trailing: isSelected
                                                ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                                                : Icon(Icons.radio_button_unchecked),
                                            onTap: ()  {
                                              context.read<FilterBloc>().updateCategory(
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
                                    text: selectedCategory?.name ?? "",
                                  ),
                                  label: getTranslated("class"),
                                  hint: getTranslated("class"),
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
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
