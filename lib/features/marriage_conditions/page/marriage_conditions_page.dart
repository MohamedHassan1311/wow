import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/validation.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_text_form_field.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/personal_info/bloc/personal_profile_bloc.dart';
import 'package:wow/features/setting_option/bloc/setting_option_bloc.dart';
import 'package:wow/features/setting_option/repo/setting_option_repo.dart';
import 'package:wow/main_models/custom_field_model.dart';
import '../bloc/marriage_conditions_bloc.dart';
import '../repo/marriage_conditions_repo.dart';

class MarriageConditionsPage extends StatelessWidget {
  const MarriageConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("marriage_conditions", context: context),
      ),
      body: BlocProvider(
        create: (context) => MarriageConditionsBloc(
          repo: sl<MarriageConditionsRepo>(),
          internetConnection: sl<InternetConnection>(),
        ),
        child: BlocBuilder<MarriageConditionsBloc, AppState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: BlocProvider(
                      create: (context) => SettingOptionBloc(
                          repo: sl<SettingOptionRepo>())
                        ..add(Get(
                            arguments: {'field_name': "marriage_condition"})),
                      child: BlocBuilder<SettingOptionBloc, AppState>(
                          builder: (context, state) {
                        if (state is Done) {
                          CustomFieldsModel model =
                              state.model as CustomFieldsModel;

                          return StreamBuilder<List<int>?>(
                              stream: context
                                  .read<MarriageConditionsBloc>()
                                  .marriageConditions,
                              builder: (context, snapshot) {
                                return Column(
                                  spacing: 12,
                                  children: [
                                    Text(
                                      getTranslated(
                                              "marriage_conditions_desc") ??
                                          "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        color: Styles.HEADER,
                                      ),
                                      maxLines: 3,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: model.data?.length,
                                        itemBuilder: (context, index) {
                                          return CheckboxListTile(
                                            value: snapshot.data?.contains(
                                                    model.data?[index].id) ??
                                                false,
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            title: Text(
                                                model.data?[index].name ?? ""),
                                            onChanged: (bool? value) {
                                              if (snapshot.data != null) {
                                                {
                                                  final updateList =
                                                      snapshot.data;
                                                  if (snapshot.data?.contains(
                                                          model.data?[index]
                                                              .id) ==
                                                      false) {
                                                    updateList?.add(
                                                        model.data?[index].id);
                                                  } else {
                                                    updateList?.remove(
                                                        model.data?[index].id);
                                                  }
                                                  context
                                                      .read<
                                                          MarriageConditionsBloc>()
                                                      .updateMarriageConditions(
                                                          updateList);
                                                }
                                              } else {
                                                context
                                                    .read<
                                                        MarriageConditionsBloc>()
                                                    .updateMarriageConditions([
                                                  model.data?[index].id
                                                ]);
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    CustomTextField(
                                      controller: context
                                          .read<MarriageConditionsBloc>()
                                          .marriageConditionsController,
                                      isEnabled: true,
                                      label: getTranslated("other_condition"),
                                      hint:
                                          "${getTranslated("enter")} ${getTranslated("other_condition")}",
                                      inputType: TextInputType.name,
                                      pSvgIcon: SvgImages.user,
                                      validate: Validations.field,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                          vertical:
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                      child: SafeArea(
                                        bottom: true,
                                        child: CustomButton(
                                          text: getTranslated("save",
                                              context: context),
                                          isLoading: context
                                              .read<MarriageConditionsBloc>()
                                              .state is Loading,
                                          onTap: () {
                                            context
                                                .read<MarriageConditionsBloc>()
                                                .add(Add());
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
