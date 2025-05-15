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
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
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
                    BlocProvider(
                      create: (context) => SettingOptionBloc(
                          repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "social_status"})),
                      child: BlocBuilder<SettingOptionBloc, AppState>(
                          builder: (context, state) {
                        if (state is Done) {
                          CustomFieldsModel model =
                              state.model as CustomFieldsModel;

                          return StreamBuilder<CustomFieldModel?>(
                              stream:
                                  context.read<FilterBloc>().socialStatusStream,
                              builder: (context, snapshot) {
                                return Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated("social_status"),
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
                                                      .socialStatus
                                                      .value ==
                                                  hobby)
                                                context
                                                    .read<FilterBloc>()
                                                    .updateSocialStatus(null);
                                              else
                                                context
                                                    .read<FilterBloc>()
                                                    .updateSocialStatus(hobby);
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
                      create: (context) => SettingOptionBloc(
                          repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "account_type"})),
                      child: BlocBuilder<SettingOptionBloc, AppState>(
                          builder: (context, state) {
                        if (state is Done) {
                          CustomFieldsModel model =
                              state.model as CustomFieldsModel;

                          return StreamBuilder<CustomFieldModel?>(
                              stream: context.read<FilterBloc>().categoryStream,
                              builder: (context, snapshot) {
                                return Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated("class"),
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
                                                      .category
                                                      .value ==
                                                  hobby)
                                                context
                                                    .read<FilterBloc>()
                                                    .updateCategory(null);
                                              else
                                                context
                                                    .read<FilterBloc>()
                                                    .updateCategory(hobby);
                                            },
                                            child: CustomSelectWidget(
                                                hobby: hobby,
                                                isSelected: snapshot.data == hobby)
                                         
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
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
