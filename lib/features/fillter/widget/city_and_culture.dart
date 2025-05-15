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

class CityAndCulture extends StatefulWidget {
  const CityAndCulture({super.key});

  @override
  State<CityAndCulture> createState() => _CityAndCultureState();
}

class _CityAndCultureState extends State<CityAndCulture>  with AutomaticKeepAliveClientMixin{
  BuildContext? cityBlocContext;

  @override
  Widget build(BuildContext context) {
        super.build(context); // For keep-alive

    return Form(
      child: ListAnimator(
        scroll: false,
        data: [
               /// other nationality
                BlocProvider(
                  create: (context) =>
                      SettingOptionBloc(repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments: {'field_name': "country"})),
                  child: BlocBuilder<SettingOptionBloc, AppState>(
                      builder: (context, state) {
                    if (state is Done) {
                      CustomFieldsModel model =
                          state.model as CustomFieldsModel;

                      return StreamBuilder<CustomFieldModel?>(
                          stream: context.read<FilterBloc>().countryStream,
                          builder: (context, snapshot) {
                              return Column(
                                spacing: 12,
                                children: [
                                  BlocProvider(
                                    create: (context) => SettingOptionBloc(
                                        repo: sl<SettingOptionRepo>())
                                      ..add(Get(arguments: {
                                        'field_name': "country"
                                      })),
                                    child: BlocBuilder<SettingOptionBloc,
                                        AppState>(builder: (context, state) {
                                      if (state is Done) {
                                        CustomFieldsModel model =
                                            state.model as CustomFieldsModel;

                                        return StreamBuilder<CustomFieldModel?>(
                                            stream: context
                                                .read<FilterBloc>()
                                                .countryStream,
                                            builder: (context, snapshot) {
                                              return Column(
                                                spacing: 5,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    getTranslated("country"),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Wrap(
                                                    children: model.data!.map(
                                                      (hobby) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            if (context
                                                                    .read<
                                                                        FilterBloc>()
                                                                    .country
                                                                    .value ==
                                                                hobby) {
                                                              context
                                                                  .read<
                                                                      FilterBloc>()
                                                                  .updateCountry(
                                                                      null);


                                                            } else
                                                     {         context
                                                                  .read<
                                                                      FilterBloc>()
                                                                  .updateCountry(
                                                                      hobby);


                                                                           cityBlocContext
                                                                  ?.read<
                                                                      SettingOptionBloc>()
                                                                  .add(Get(
                                                                      arguments: {
                                                                        'field_name':
                                                                            "city",
                                                                        "country_id": context
                                                                            .read<FilterBloc>()
                                                                            .country
                                                                            .valueOrNull!
                                                                            .id
                                                                      }));
                                                                      }
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

                                  /// City
                                  Visibility(
                                    visible: context
                                            .read<FilterBloc>()
                                            .country
                                            .valueOrNull !=
                                        null,
                                    child: BlocProvider(
                                      create: (context) => SettingOptionBloc(
                                          repo: sl<SettingOptionRepo>())
                                        ..add(Get(arguments: {
                                          'field_name': "city",
                                          "country_id": context
                                              .read<FilterBloc>()
                                              .country
                                              .valueOrNull!
                                              .id
                                        })),
                                      child: BlocBuilder<SettingOptionBloc,
                                          AppState>(builder: (context, state) {
                                        cityBlocContext = context;

                                        if (state is Done) {
                                          CustomFieldsModel model =
                                              state.model as CustomFieldsModel;

                                          return StreamBuilder<
                                                  CustomFieldModel?>(
                                              stream: context
                                                  .read<FilterBloc>()
                                                  .cityStream,
                                              builder: (context, snapshot) {
                                                return Column(
                                                  spacing: 5,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      getTranslated("city"),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Wrap(
                                                      children: model.data!.map(
                                                        (hobby) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              if (context
                                                                      .read<
                                                                          FilterBloc>()
                                                                      .city
                                                                      .value ==
                                                                  hobby)
                                                                context
                                                                    .read<
                                                                        FilterBloc>()
                                                                    .updateCity(
                                                                        null);
                                                              else
                                                                context
                                                                    .read<
                                                                        FilterBloc>()
                                                                    .updateCity(
                                                                        hobby);
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
                          stream: context.read<FilterBloc>().cultureStream,
                          builder: (context, snapshot) {
                            return Column(
                              spacing: 5,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getTranslated("culture"),
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
                                                  .culture
                                                  .value ==
                                              hobby)
                                            context
                                                .read<FilterBloc>()
                                                .updateCulture(null);
                                          else
                                            context
                                                .read<FilterBloc>()
                                                .updateCulture(hobby);
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


        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
