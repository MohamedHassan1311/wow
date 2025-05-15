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
              initiallyExpanded: true,
              title: getTranslated("fashion_style"),
              children: [
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
                          stream: context.read<FilterBloc>().hijabStream,
                          builder: (context, snapshot) {
                            return Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated("hijab"),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Wrap(
                                  children: model.data!.map(
                                    (hobby) {
                                      return GestureDetector(
                                        onTap: () {
                                          if (context
                                                  .read<FilterBloc>()
                                                  .hijab
                                                  .value ==
                                              hobby)
                                            context
                                                .read<FilterBloc>()
                                                .updateHijab(null);
                                          else
                                            context
                                                .read<FilterBloc>()
                                                .updateHijab(hobby);
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
                        ..add(Get(arguments: {'field_name': "abaya"})),
                  child: BlocBuilder<SettingOptionBloc, AppState>(
                      builder: (context, state) {
                    if (state is Done) {
                      CustomFieldsModel model =
                          state.model as CustomFieldsModel;

                      return StreamBuilder<CustomFieldModel?>(
                          stream: context.read<FilterBloc>().abyaStream,
                          builder: (context, snapshot) {
                            return Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated("abya"),
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
                                                  .abya
                                                  .value ==
                                              hobby)
                                            context
                                                .read<FilterBloc>()
                                                .updateAbya(null);
                                          else
                                            context
                                                .read<FilterBloc>()
                                                .updateAbya(hobby);
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
