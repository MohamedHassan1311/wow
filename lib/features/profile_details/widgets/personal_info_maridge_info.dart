import 'package:flutter/material.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/features/profile_details/widgets/details_row.dart';
import 'package:wow/main_models/user_model.dart';

class PersonalInfoMaridgeInfo extends StatelessWidget {
  final UserModel user;
  const PersonalInfoMaridgeInfo({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT / 2,
          vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [
          if (user.marriageCondition?.isNotEmpty ?? false)
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: user.marriageCondition?.length,
                itemBuilder: (context, index) {
                  return Text(user.marriageCondition?[index].name ?? '',
                      style: AppTextStyles.w600
                          .copyWith(fontSize: 16, color: Styles.HEADER));
                },
              ),
            ),
          if (user.marriageCondition?.isEmpty ?? true)
            EmptyState(
              imgHeight: 60,
              imgWidth: 60,
            )
        ],
      ),
    );
  }
}
