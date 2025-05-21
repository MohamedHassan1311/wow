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
                          stream: context.read<FilterBloc>().healthStream,
                          builder: (context, snapshot) {
                            return Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated("health"),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: model.data!.map(
                                    (hobby) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (context
                                                  .read<FilterBloc>()
                                                  .health
                                                  .value ==
                                              hobby)
                                            context
                                                .read<FilterBloc>()
                                                .updateHealth(null);
                                          else
                                            context
                                                .read<FilterBloc>()
                                                .updateHealth(hobby);
                                        },
                                        child: CustomSelectWidget(
                                          hobby: hobby,
                                          isSelected: snapshot.data == hobby,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                )
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
                          stream: context.read<FilterBloc>().lifestyleStream,
                          builder: (context, snapshot) {
                            return Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated("lifestyle"),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: model.data!.map(
                                    (hobby) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (context
                                                  .read<FilterBloc>()
                                                  .lifestyle
                                                  .value ==
                                              hobby)
                                            context
                                                .read<FilterBloc>()
                                                .updateLifestyle(null);
                                          else
                                            context
                                                .read<FilterBloc>()
                                                .updateLifestyle(hobby);
                                        },
                                        child: CustomSelectWidget(
                                          hobby: hobby,
                                          isSelected: snapshot.data == hobby,
                                        ),
                                      );
                                    },
                                  ).toList(),
                                )
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
              ]),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
