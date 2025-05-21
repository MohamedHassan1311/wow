import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/features/profile_details/widgets/details_row.dart';
import 'package:wow/main_models/user_model.dart';

class PersonalInfoTapSectAndTribe extends StatelessWidget {
  final UserModel user;
  const PersonalInfoTapSectAndTribe({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT / 2,
          vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [
      

      
          const SizedBox(height: 12),
          DetailsRow(title: getTranslated("Sect", context: context), value: user.sect?.name ?? ''),
          DetailsRow(title: getTranslated("tribe", context: context), value: user.tribe?.name ?? ''),
          DetailsRow(title: getTranslated("body_type", context: context), value: user.bodyType?.name ?? ''),
      
        ],
      ),
    );
  }
}
