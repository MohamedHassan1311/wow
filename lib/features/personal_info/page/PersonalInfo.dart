import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/dimensions.dart';

import '../../../../data/config/di.dart';
import '../bloc/personal_profile_bloc.dart';
import '../repo/perosnal_info_repo.dart';

import '../widget/personal_info_actions.dart';
import '../widget/personal_info_header.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalInfoBloc(repo: sl<PersonalInfoRepo>()),
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: BlocBuilder<PersonalInfoBloc, AppState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  PersonalInfoHeader(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      child: PageView(
                        controller:
                            context.read<PersonalInfoBloc>().pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        pageSnapping: true,
                        children: [
                          // CompleteProfileNameAndGender(),
                          // CompleteProfileNationalityAndCountry(),
                          // CompleteProfileMaritalStatus(),
                          // CompleteProfileGuardiandata(),
                          // CompleteProfileVerification()
                        ],
                      ),
                    ),
                  ),

                  PersonalInfoActions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
