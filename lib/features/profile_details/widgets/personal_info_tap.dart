import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/features/profile_details/widgets/details_row.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';

class PersonalInfoTap extends StatelessWidget {
  final UserModel user;
  const PersonalInfoTap({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT / 2,
          vertical: Dimensions.PADDING_SIZE_DEFAULT),
      child: ListView(
        children: [
          Row(
            children: [
              Text(
                '${user.name} , ${user.age}',
                style: AppTextStyles.w700
                    .copyWith(fontSize: 20, color: Styles.HEADER),
              ),
              if (user.isVerified == 1)
                Icon(Icons.verified, color: Colors.blue, size: 20),
              SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            user.personalInfo ?? '',
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),
          Text(getTranslated("details", context: context),
              style: AppTextStyles.w700
                  .copyWith(fontSize: 16, color: Styles.HEADER)),
          const SizedBox(height: 12),
          DetailsRow(
              title: getTranslated("skin_color", context: context),
              value: user.skinColor?.name ?? ''),
          DetailsRow(
              title: getTranslated("weight", context: context),
              value: user.weight.toString() ?? ''),
          DetailsRow(
              title: getTranslated("height", context: context),
              value: user.height.toString() ?? ''),
          DetailsRow(
              title: getTranslated("body_type", context: context),
              value: user.bodyType?.name ?? ''),
          DetailsRow(
              title: getTranslated("social_status", context: context),
              value: user.socialStatus?.name ?? ''),
          const SizedBox(height: 24),
          if (user.gender == "F")
            Image.asset(
              Images.zwagcard,
              width: context.width,
              height: context.height * .25,
            ),
        ],
      ),
    );
  }
}
