import 'package:flutter/widgets.dart';

import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_images.dart';

class ContactWithUsHeader extends StatelessWidget {
  const ContactWithUsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
            child: customImageIcon(
                imageName: Images.authLogo, width: 230.w, height: 130.h)),
        Text(
          getTranslated("contact_with_us_header"),
          textAlign: TextAlign.center,
          style: AppTextStyles.w700
              .copyWith(fontSize: 28, color: Styles.PRIMARY_COLOR),
        ),
        SizedBox(height: 4.h),
        Text(
          getTranslated("contact_with_us_description"),
          textAlign: TextAlign.center,
          style: AppTextStyles.w500.copyWith(fontSize: 18, color: Styles.TITLE),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE.h),
      ],
    );
  }
}
