import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import '../../../../app/core/dimensions.dart';

import '../../../../data/config/di.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_alert_dialog.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/custom_request_dialog.dart';
import '../../payment/bloc/payment_bloc.dart';
import '../bloc/complete_profile_bloc.dart';
import '../repo/complete_profile_repo.dart';
import '../widget/complete_profile_actions.dart';
import '../widget/complete_profile_guardian_data.dart';
import '../widget/complete_profile_name_and_gender.dart';
import '../widget/complete_profile_nationality_and_country.dart';
import '../widget/complete_profile_marital_status.dart';
import '../widget/complete_profile_header.dart';
import '../widget/complete_profile_verification.dart';

class CompleteProfile extends StatefulWidget {
  final bool isEdit;
  const CompleteProfile({super.key, this.isEdit = false});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  @override
  void initState() {
    super.initState(); // should be called first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleEditFee();
    });
  }

  void _handleEditFee() async {
    if (UserBloc.instance.user?.editFee != "0") {
      CustomNavigator.pop();
      await CustomAlertDialog.show(
        dailog: AlertDialog(
          contentPadding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
          ),
          shape: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: CustomDialog(
            name: getTranslated("edit_fees"),
            confirmButtonText: getTranslated("payment"),
            showSympole: true,
            discription: getTranslated("accountـmodificationـfee").replaceAll(
              "#", UserBloc.instance.user!.editFee.toString(),
            ),
            image: SvgImages.wallet,
          ),
        ),
      );

      sl.get<PaymentBloc>().payRequestNowReadyUI(
        checkoutlink: UserBloc.instance.user!.checkoutLink.toString(),
        pop: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: widget.isEdit
          ? (c) {
              return CompleteProfileBloc(repo: sl<CompleteProfileRepo>())
                ..onInit();
            }
          : (c) => CompleteProfileBloc(repo: sl<CompleteProfileRepo>()),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: BlocBuilder<CompleteProfileBloc, AppState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  CompleteProfileHeader(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: PageView(
                        controller:
                            context.read<CompleteProfileBloc>().pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        pageSnapping: true,
                        children: [
                          CompleteProfileNameAndGender(isEdit: widget.isEdit,),
                          CompleteProfileNationalityAndCountry(isEdit: widget.isEdit,),
                          CompleteProfileMaritalStatus(isEdit: widget.isEdit,),
                          CompleteProfileGuardiandata(isEdit: widget.isEdit,),
                          CompleteProfileVerification(isEdit: widget.isEdit,),
                        ],
                      ),
                    ),
                  ),
                  CompleteProfileActions(isEdit:widget.isEdit ,),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
