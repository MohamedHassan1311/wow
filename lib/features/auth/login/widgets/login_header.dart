import 'package:flutter/widgets.dart';
import 'package:wow/components/custom_images.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/images.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../language/page/language_button.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LanguageButton(fromWelcome: true,),
        Center(
          child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
              child: Image.asset(
                  Images.splash,  fit:BoxFit.contain,width: 130.h, height: 130.h)),
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   children: [
        //     Text(
        //       getTranslated("login_header"),
        //       style: AppTextStyles.w700
        //           .copyWith(fontSize: 24, ),
        //     ),
        //     SizedBox(width: 6.w),
        //     customImageIcon(
        //         imageName: Images.logoWord,
        //         height: 24.h,
        //         width:24.h,
        //         fit: BoxFit.contain)
        //   ],
        // ),
        // SizedBox(height: 4.h),
        // Text(
        //   getTranslated("login_description"),
        //   style: AppTextStyles.w400.copyWith(fontSize: 20, color: Styles.TITLE),
        // ),
        SizedBox(height: Dimensions.PADDING_SIZE_LARGE.h),
      ],
    );
  }
}
