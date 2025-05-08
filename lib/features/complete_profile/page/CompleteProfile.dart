import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/dimensions.dart';

import '../../../../data/config/di.dart';
import '../bloc/complete_profile_bloc.dart';
import '../repo/complete_profile_repo.dart';
import '../widget/complete_profile_actions.dart';
import '../widget/complete_profile_guardian_data.dart';
import '../widget/complete_profile_name_and_gender.dart';
import '../widget/complete_profile_nationality_and_country.dart';
import '../widget/complete_profile_marital_status.dart';
import '../widget/complete_profile_header.dart';
import '../widget/complete_profile_verification.dart';

class CompleteProfile extends StatelessWidget {
  final bool isEdit;
  const CompleteProfile({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: isEdit
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
                          CompleteProfileNameAndGender(),
                          CompleteProfileNationalityAndCountry(),
                          CompleteProfileMaritalStatus(),
                          CompleteProfileGuardiandata(),
                          CompleteProfileVerification()
                        ],
                      ),
                    ),
                  ),
                  CompleteProfileActions(isEdit:isEdit ,),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
