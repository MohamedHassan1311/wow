import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/features/profile_details/widgets/details_row.dart';
import 'package:wow/main_models/user_model.dart';

class PersonalInfoTapCountry extends StatelessWidget {
  final UserModel user;
  const PersonalInfoTapCountry({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT / 2,
          vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: Column(
        children: [
      

      
          const SizedBox(height: 12),
          DetailsRow(title: getTranslated("nationality", context: context), value: user.nationalityId?.name ?? ''),
                    DetailsRow(title: getTranslated("country", context: context), value: user.countryId?.name ?? ''),

          DetailsRow(title: getTranslated("city", context: context), value: user.cityId?.name ?? ''),

          
        ],
      ),
    );
  }
}
