import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';

import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/personal_profile_bloc.dart';

class PersonalInfoEducation extends StatefulWidget {
  const PersonalInfoEducation({super.key});

  @override
  State<PersonalInfoEducation> createState() => _PersonalInfoEducationState();
}

class _PersonalInfoEducationState extends State<PersonalInfoEducation>
    with AutomaticKeepAliveClientMixin {
  BuildContext? cityBlocContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<PersonalInfoBloc>().formKey1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              /// other nationality
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "education"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<CustomFieldModel?>(
                        stream:
                            context.read<PersonalInfoBloc>().educationStream,
                        builder: (context, snapshot) {
                          return CustomDropDownButton(
                            label: getTranslated("education_level"),
                            value: null,
                            onChange: (v) {
                              context
                                  .read<PersonalInfoBloc>()
                                  .updateEducation(v as CustomFieldModel);
                            },
                            items: model.data ?? [],
                            name: context
                                    .read<PersonalInfoBloc>()
                                    .education
                                    .valueOrNull
                                    ?.name ??
                                getTranslated("education_level"),
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

              ///education_level_2
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "education"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<CustomFieldModel?>(
                        stream: context.read<PersonalInfoBloc>().education2,
                        builder: (context, snapshot) {
                          return Column(
                            spacing: 12,
                            children: [
                              CustomDropDownButton(
                                label: getTranslated("education_level_2"),
                                validation: (v) =>
                                    Validations.field(snapshot.data?.name),
                                value: null,
                                onChange: (v) {
                                  context
                                      .read<PersonalInfoBloc>()
                                      .updateEducation2(v as CustomFieldModel);
                                },
                                items: model.data ?? [],
                                name: context
                                        .read<PersonalInfoBloc>()
                                        .education2
                                        .valueOrNull
                                        ?.name ??
                                    getTranslated("education_level_2"),
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
              //Speeking languages
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "languages"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<List<int>?>(
                        stream: context.read<PersonalInfoBloc>().languages,
                        builder: (context, snapshot) {
                          return Container(
                            height: 280,
                            child: Column(
                              spacing: 12,
                              children: [
                                Text(
                                getTranslated("Languages you speak")?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    overflow: TextOverflow.ellipsis,
                                    color: Styles.HEADER,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: model.data?.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // Number of columns
                                        childAspectRatio:
                                            3, // Adjust height vs width
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                      ),
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          value: snapshot.data?.contains(
                                                  model.data?[index].id) ??
                                              false,
                                          controlAffinity: ListTileControlAffinity.leading,
                                          title: Text(
                                              model.data?[index].name ?? ""),
                                          onChanged: (bool? value) {
                                            if (snapshot.data != null) {
                                            {
                                                final updateList =
                                                    snapshot.data;
                                                if(snapshot.data?.contains(
                                                    model.data?[index].id)==false ) {
                                                  updateList?.add(
                                                    model.data?[index].id);
                                                }
                                                else{
                                                  updateList?.remove(
                                                      model.data?[index].id);
                                                }
                                                context
                                                    .read<PersonalInfoBloc>()
                                                    .updateLanguages(
                                                        updateList);
                                              }


                                            } else {
                                              context
                                                  .read<PersonalInfoBloc>()
                                                  .updateLanguages(
                                                      [model.data?[index].id]);
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
