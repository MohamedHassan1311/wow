import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_wheel_date_picker/scroll_wheel_date_picker.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_drop_down_button.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_models/custom_field_model.dart';
import '../../setting_option/bloc/setting_option_bloc.dart';
import '../../setting_option/repo/setting_option_repo.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileMaritalStatus extends StatefulWidget {
  final bool isEdit;
  final bool isAdd;
  final bool isView;
  const CompleteProfileMaritalStatus({super.key,  this.isAdd=true,  this.isView=false,this.isEdit=false});

  @override
  State<CompleteProfileMaritalStatus> createState() => _CompleteProfileMaritalStatusState();
}

class _CompleteProfileMaritalStatusState extends State<CompleteProfileMaritalStatus>with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CompleteProfileBloc, AppState>(
      builder: (context, state) {
        print("context.read<CompleteProfileBloc>().dop.value ${context.read<CompleteProfileBloc>().dop.value}");
        return Form(
            key: context.read<CompleteProfileBloc>().formKey3,
            child: ListAnimator(
              scroll:widget. isAdd,
              data: [
                Center(
                  child: Text(
                   getTranslated("select_your_birth") ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                      color: Styles.HEADER,
                    ),
                  ),
                ),
                ScrollWheelDatePicker(
                  initialDate:context.read<CompleteProfileBloc>().dop.value,
                  onSelectedItemChanged: (d){

                    context
                        .read<CompleteProfileBloc>().updateDOP(d);
                  },
                  theme: FlatDatePickerTheme(
                    backgroundColor: Colors.white,
                    overlay: ScrollWheelDatePickerOverlay.holo,
                    itemTextStyle: defaultItemTextStyle.copyWith(color: Colors.black),
                    overlayColor: Colors.black45,
                    overAndUnderCenterOpacity: 0.4,
                  ),
                ),
                BlocProvider(
                  create: (context) =>!widget.isAdd
                      ? SettingOptionBloc(repo: sl<SettingOptionRepo>()):
                      SettingOptionBloc(repo: sl<SettingOptionRepo>())
                        ..add(Get(arguments:{'field_name': "social_status"} )),
                  child: BlocBuilder<SettingOptionBloc, AppState>(
                      builder: (context, state) {
                    if (state is Done) {
                      CustomFieldsModel model =
                          state.model as CustomFieldsModel;

                      return StreamBuilder<CustomFieldModel?>(
                          stream: context
                              .read<CompleteProfileBloc>()
                              .socialStatusStream,
                          builder: (context, snapshot) {
                            if(snapshot.data!=null){
                            return Column(
                              children: [
                                CustomDropDownButton(
                                  label: getTranslated( "Marital status"),
                                  labelErorr: UserBloc
                                      .instance.user?.validation?.socialStatus,
                                  validation: (v) =>
                                      Validations.field(snapshot.data?.name),
                                  value: snapshot.data != null
                                      ? model.data?.where((v) {

                                    return v.id == snapshot.data!.id;
                                  }).firstOrNull
                                      : null,
                                  isEnabled:widget.isEdit?snapshot.data!=null&& UserBloc.instance.user?.validation?.socialStatus!=null:true,

                                  items: model.data ?? [],
                                  onChange: (v) {
                                    context
                                        .read<CompleteProfileBloc>()
                                        .updateSocialStatus(v as CustomFieldModel);
                                  },
                                  name: context
                                          .read<CompleteProfileBloc>()
                                          .nationality
                                          .valueOrNull
                                          ?.name ??
                                      getTranslated("nationality"),
                                ),
                                if(snapshot.data?.id!=3)
                                  CustomTextField(
                                    controller:
                                    context.read<CompleteProfileBloc>().numberOfChildren,
                                    label: getTranslated("number_of_children"),
                                    isEnabled:widget.isEdit?snapshot.data?.id==3&& UserBloc.instance.user?.validation?.numOfSons!=null:true,
                                    labelError: UserBloc
                                        .instance.user?.validation?.numOfSons,
                                    hint:
                                    "${getTranslated("enter")} ${getTranslated("number_of_children")}",
                                    inputType: TextInputType.number,
                                    pSvgIcon: SvgImages.user,
                                  ),
                              ],
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

              ],
            ));
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
