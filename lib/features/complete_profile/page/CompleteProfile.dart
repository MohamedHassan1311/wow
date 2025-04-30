import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../components/animated_widget.dart';
import '../../../../data/config/di.dart';
import '../../../app/core/styles.dart';
import '../bloc/complete_profile_bloc.dart';
import '../repo/complete_profile_repo.dart';
import '../widget/complete_profile_actions.dart';
import '../widget/complete_profile_body_step1.dart';
import '../widget/complete_profile_body_step2.dart';
import '../widget/complete_profile_body_step3.dart';
import '../widget/complete_profile_body_step4.dart';
import '../widget/complete_profile_header.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompleteProfileBloc(repo: sl<CompleteProfileRepo>()),
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
                          CompleteProfileBodyStpe1(),
                          CompleteProfileBodyStep2(),
                          CompleteProfileBodyStep3(),
                          CompleteProfileBodyStpe4()
                        ],
                      ),
                    ),
                  ),

                  CompleteProfileActions(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
