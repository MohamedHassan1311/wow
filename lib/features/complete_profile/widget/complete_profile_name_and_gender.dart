
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/svg_images.dart';

import 'package:wow/features/complete_profile/widget/select_gender.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/validation.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_text_form_field.dart';

import '../../../components/animated_widget.dart';
import '../bloc/complete_profile_bloc.dart';

class CompleteProfileNameAndGender extends StatefulWidget {
  final bool  scroll;
  final bool isEdit;

  const CompleteProfileNameAndGender({super.key,  this.scroll=true,this.isEdit=false});

  @override
  State<CompleteProfileNameAndGender> createState() => _CompleteProfileNameAndGenderState();
}

class _CompleteProfileNameAndGenderState extends State<CompleteProfileNameAndGender> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CompleteProfileBloc, AppState>(
      builder: (context, state) {
        return Form(
          key: context.read<CompleteProfileBloc>().formKey1 ,
          child: ListAnimator(
            scroll:widget. scroll,
            data: [
                    // ///Name
                    CustomTextField(
                      controller:
                      context.read<CompleteProfileBloc>().fName,
                   isEnabled: widget.isEdit? context.read<CompleteProfileBloc>().fName.text.isNotEmpty&& UserBloc.instance.user?.validation?.fname!=null:true,

                      label: getTranslated("First_name"),
                      labelError: UserBloc.instance.user?.validation?.fname,
                      hint:
                      "${getTranslated("enter")} ${getTranslated("First_name")}",
                      inputType: TextInputType.name,
                      pSvgIcon: SvgImages.user,
                      validate: Validations.name,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomTextField(
                      controller:
                      context.read<CompleteProfileBloc>().lName,
                      isEnabled: widget.isEdit? context.read<CompleteProfileBloc>().lName.text.isNotEmpty&& UserBloc.instance.user?.validation?.lname!=null:true,
                      label: getTranslated("Second_name"),
                      labelError: UserBloc.instance.user?.validation?.lname,
                      hint:
                      "${getTranslated("enter")} ${getTranslated("Second_name")}",
                      inputType: TextInputType.name,
                      pSvgIcon: SvgImages.user,
                      validate: Validations.name,
                    ),
                    CustomTextField(
                      controller:
                      context.read<CompleteProfileBloc>().nickname,
                      isEnabled: widget.isEdit? context.read<CompleteProfileBloc>().nickname.text.isNotEmpty&& UserBloc.instance.user?.validation?.nickname!=null:true,
                      label: getTranslated("user_name"),
                      labelError: UserBloc.instance.user?.validation?.nickname,

                      hint:
                      "${getTranslated("enter")} ${getTranslated("user_name")}",
                      inputType: TextInputType.name,
                      pSvgIcon: SvgImages.user,
                      validate: Validations.name,
                    ),

                    Text(
                      getTranslated("gender") ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                        color: Styles.HEADER,
                      ),
                    ),
                    SizedBox(height: 10,),
                    SelectGender(),
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
