import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/features/profile_details/widgets/details_row.dart';
import 'package:wow/main_models/user_model.dart';

class PersonalInfoTapEducation extends StatelessWidget {
  final UserModel user;
  const PersonalInfoTapEducation({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT / 2,
          vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [



          const SizedBox(height: 12),
          DetailsRow(title: getTranslated("education", context: context), value: user.education?.name ?? ''),
                    DetailsRow(title: getTranslated("education_level_2", context: context).split("(")[0], value: user.education2?.name ?? ''),

          DetailsRow(title: getTranslated("job", context: context), value: user.job ?? ''),


        ],
      ),
    );
  }
}
