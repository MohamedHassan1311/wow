import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/main_blocs/user_bloc.dart';

import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/svg_images.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/custom_field_model.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/personal_profile_bloc.dart';

class PersonalInfoJob extends StatefulWidget {
  final bool isEdit;
  const PersonalInfoJob({super.key, this.isEdit = false});

  @override
  State<PersonalInfoJob> createState() => _PersonalInfoJobState();
}

class _PersonalInfoJobState extends State<PersonalInfoJob>
    with AutomaticKeepAliveClientMixin {
  BuildContext? cityBlocContext;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<PersonalInfoBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<PersonalInfoBloc>().formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              /// job_title
              BlocProvider(
                create: (context) =>
                    SettingOptionBloc(repo: sl<SettingOptionRepo>())
                      ..add(Get(arguments: {'field_name': "job_title"})),
                child: BlocBuilder<SettingOptionBloc, AppState>(
                    builder: (context, state) {
                  if (state is Done) {
                    CustomFieldsModel model = state.model as CustomFieldsModel;

                    return StreamBuilder<CustomFieldModel?>(
                        stream: context.read<PersonalInfoBloc>().jobStream,
                        builder: (context, snapshot) {
                          if(snapshot.data!=null){
                          return CustomDropDownButton(
                            label: getTranslated("job"),
                            value: model.data?.firstWhere(
                              (v) => v.name == snapshot.data?.name,
                              orElse: () => CustomFieldModel(name: "no_data"),
                            ),

                            onChange: (v) {
                              context
                                  .read<PersonalInfoBloc>()
                                  .updateJob(v as CustomFieldModel);
                            },
                            items: model.data ?? [],
                            name: context
                                    .read<PersonalInfoBloc>()
                                    .job
                                    .valueOrNull
                                    ?.name ??
                                getTranslated("job"),
                          );
                        }
                        return SizedBox();
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

              // ///Name
              CustomTextField(
                controller: context.read<PersonalInfoBloc>().otherJob,
                label: getTranslated("anther_job"),
                hint: "${getTranslated("enter")} ${getTranslated("job")}",
                inputType: TextInputType.name,
                pSvgIcon: SvgImages.user,
                // isEnabled: widget.isEdit? context.read<PersonalInfoBloc>().otherJob.text.isNotEmpty&& UserBloc.instance.user?.validation?.job != null:true,
              ),

              CustomTextField(
                controller: context.read<PersonalInfoBloc>().salery,
                label: getTranslated("salary"),
                hint: "${getTranslated("enter")} ${getTranslated("salary")}",
                inputType: TextInputType.number,
                pSvgIcon: SvgImages.user,
                // validate: Validations.field,
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
