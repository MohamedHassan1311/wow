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
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/custom_field_model.dart';

import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../navigation/custom_navigation.dart';

class CityAndCulture extends StatefulWidget {
  const CityAndCulture({super.key});

  @override
  State<CityAndCulture> createState() => _CityAndCultureState();
}

class _CityAndCultureState extends State<CityAndCulture>
    with AutomaticKeepAliveClientMixin {
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
               final List<CustomFieldModel> countryList;
                  if (UserBloc.instance.user?.nationalityId?.code != "sa") {
                    countryList = (state.model as CustomFieldsModel)
                            .data
                            ?.where((m) => m.code != "SA")
                            .toList() ??
                        [];
                  }
                  else{
                    countryList = (state.model as CustomFieldsModel)
                        .data ??
                        [];
                  }

                  return StreamBuilder<CustomFieldModel?>(
                    stream: context.read<FilterBloc>().countryStream,
                    builder: (context, snapshot) {
                      final selectedCountry = snapshot.data;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          /// COUNTRY FIELD
                          CustomTextField(
                            readOnly: true,
                            sufWidget: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Styles.ACCENT_COLOR,
                            ),
                            onTap: () {
                              CustomBottomSheet.show(
                                label: getTranslated("country"),
                                onCancel: () => CustomNavigator.pop(),
                                onConfirm: () => CustomNavigator.pop(),
                                widget: ListView(
                                  shrinkWrap: true,
                                  children: countryList.map((item) {
                                    final isSelected = selectedCountry == item;

                                    return ListTile(
                                      title: Text(item.name ?? ""),
                                      trailing: isSelected
                                          ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                                          : Icon(Icons.radio_button_unchecked),
                                      onTap: () {
                                        if (isSelected) {
                                          context
                                              .read<FilterBloc>()
                                              .updateCountry(null);
                                        } else {
                                          context
                                              .read<FilterBloc>()
                                              .updateCountry(item);

                                          /// Trigger city loading
                                          cityBlocContext
                                              ?.read<SettingOptionBloc>()
                                              ?.add(
                                                Get(arguments: {
                                                  'field_name': "city",
                                                  "country_id": item.id,
                                                }),
                                              );
                                        }

                                        CustomNavigator.pop();
                                      },
                                    );
                                  }).toList(),
                                ),
                              );
                            },
                            controller: TextEditingController(
                              text: selectedCountry?.name ?? '',
                            ),
                            label: getTranslated("country"),
                            hint: getTranslated("country"),
                          ),

                          /// CITY SECTION
                          if (selectedCountry != null)
                            BlocProvider(
                              create: (context) => SettingOptionBloc(
                                repo: sl<SettingOptionRepo>(),
                              )..add(Get(arguments: {
                                  'field_name': "city",
                                  "country_id": selectedCountry.id,
                                })),
                              child: BlocBuilder<SettingOptionBloc, AppState>(
                                builder: (context, state) {
                                  cityBlocContext = context;

                                  if (state is Done) {
                                    final cityList =
                                        (state.model as CustomFieldsModel)
                                                .data ??
                                            [];

                                    return StreamBuilder<CustomFieldModel?>(
                                      stream:
                                          context.read<FilterBloc>().cityStream,
                                      builder: (context, snapshot) {
                                        final selectedCity = snapshot.data;

                                        return CustomTextField(
                                          readOnly: true,
                                          sufWidget: const Icon(
                                            Icons.keyboard_arrow_down_rounded,
                                            color: Styles.ACCENT_COLOR,
                                          ),
                                          onTap: () {
                                            CustomBottomSheet.show(
                                              label: getTranslated("city"),
                                              onCancel: () =>
                                                  CustomNavigator.pop(),
                                              onConfirm: () =>
                                                  CustomNavigator.pop(),
                                              widget: ListView(
                                                shrinkWrap: true,
                                                children: cityList.map((item) {
                                                  final isSelected =
                                                      selectedCity == item;

                                                  return ListTile(
                                                    title: Text(item.name ?? ""),
                                                    trailing: isSelected
                                                        ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                                                        : Icon(Icons.radio_button_unchecked),
                                                    onTap: () {
                                                      if (isSelected) {
                                                        context
                                                            .read<FilterBloc>()
                                                            .updateCity(null);
                                                      } else {
                                                        context
                                                            .read<FilterBloc>()
                                                            .updateCity(item);
                                                      }

                                                      CustomNavigator.pop();
                                                    },
                                                  );
                                                }).toList(),
                                              ),
                                            );
                                          },
                                          controller: TextEditingController(
                                            text: selectedCity?.name ?? '',
                                          ),
                                          label: getTranslated("city"),
                                          hint: getTranslated("city"),
                                        );
                                      },
                                    );
                                  }

                                  if (state is Loading) {
                                    return CustomShimmerContainer(
                                      height: 60.h,
                                      width: context.width,
                                      radius: 30,
                                    );
                                  }

                                  return const SizedBox();
                                },
                              ),
                            )
                        ],
                      );
                    },
                  );
                }

                if (state is Loading) {
                  return CustomShimmerContainer(
                    height: 60.h,
                    width: context.width,
                    radius: 30,
                  );
                }

                return const SizedBox();
              },
            ),
          ),

          BlocProvider(
            create: (context) =>
                SettingOptionBloc(repo: sl<SettingOptionRepo>())
                  ..add(Get(arguments: {'field_name': "culture"})),
            child: BlocBuilder<SettingOptionBloc, AppState>(
              builder: (context, state) {
                if (state is Done) {
                  final cultureList =
                      (state.model as CustomFieldsModel).data ?? [];

                  return StreamBuilder<CustomFieldModel?>(
                    stream: context.read<FilterBloc>().cultureStream,
                    builder: (context, snapshot) {
                      final selectedCulture = snapshot.data;

                      return CustomTextField(
                        readOnly: true,
                        sufWidget: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Styles.ACCENT_COLOR,
                        ),
                        onTap: () {
                          CustomBottomSheet.show(
                            label: getTranslated("culture"),
                            onCancel: () => CustomNavigator.pop(),
                            onConfirm: () => CustomNavigator.pop(),
                            widget: ListView(
                              shrinkWrap: true,
                              children: cultureList.map((item) {
                                final isSelected = selectedCulture == item;

                                return ListTile(
                                  title: Text(item.name ?? ""),
                                  trailing: isSelected
                                      ? Icon(Icons.radio_button_checked, color: Styles.PRIMARY_COLOR)
                                      : Icon(Icons.radio_button_unchecked),
                                  onTap: () {
                                    if (isSelected) {
                                      context.read<FilterBloc>().updateCulture(null);
                                    } else {
                                      context.read<FilterBloc>().updateCulture(item);

                                    }
                                    CustomNavigator.pop();

                                  },
                                )
                                ;
                              }).toList(),
                            ),
                          );
                        },
                        controller: TextEditingController(
                          text: selectedCulture?.name ?? '',
                        ),
                        label: getTranslated("culture"),
                        hint: getTranslated("culture"),
                      );
                    },
                  );
                }

                if (state is Loading) {
                  return CustomShimmerContainer(
                    height: 60.h,
                    width: context.width,
                    radius: 30,
                  );
                }

                return const SizedBox();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
