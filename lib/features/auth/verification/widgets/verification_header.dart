import 'package:flutter/material.dart';

import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';

class VerificationHeader extends StatelessWidget {
  const VerificationHeader({super.key, required this.email});
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
     SizedBox(width: 130.w, height: 130.h),
        Text(
          getTranslated("verify_header"),
          style: AppTextStyles.w700.copyWith(
            fontSize: 24,
            color: Styles.HEADER,
          ),
        ),

        Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: getTranslated("verify_description"),
                style: AppTextStyles.w500
                    .copyWith(fontSize: 16, color: Styles.SUBTITLE),
                children: [
                  TextSpan(
                    text: " $email ",
                    style: AppTextStyles.w500.copyWith(
                      fontSize: 16,
                      color: Styles.SUBTITLE,
                    ),
                  ),
                ]),
          ),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
      ],
    );
  }
}
