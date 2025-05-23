import 'package:flutter/material.dart';

import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';

class ResetPasswordHeader extends StatelessWidget {
  const ResetPasswordHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Center(
        child: Padding(
            padding: EdgeInsets.symmetric(
                vertical:
                Dimensions.PADDING_SIZE_DEFAULT.h),
            child: Image.asset(
          Images.logoWord,
                fit: BoxFit.contain,
                width: 230.w,
                height: 130.w,)),
      ),
      Text(
        getTranslated("reset_password_header"),
        style: AppTextStyles.w700.copyWith(
          fontSize: 24,
          color: Styles.HEADER,
        ),
      ),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        child: Text(
          getTranslated("reset_password_title"),
          style: AppTextStyles.w600
              .copyWith(fontSize: 20, color: Styles.TITLE),
        ),
      ),
      Text(
        getTranslated("reset_password_description"),
        style: AppTextStyles.w500.copyWith(
            fontSize: 16, color: Styles.DETAILS_COLOR),
      ),
      SizedBox(height: Dimensions.PADDING_SIZE_SMALL.h)
    ],);
  }
}
