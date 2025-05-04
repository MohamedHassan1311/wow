import 'package:flutter/material.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';

class SubmitSuccessDialog extends StatelessWidget {
  const SubmitSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 25,
        children: [

          customImageIconSVG(
            imageName: SvgImages.shieldDone,

          ),
          Text(
            getTranslated(
                "Submit_sucess_msg"),
            textAlign: TextAlign.center,
            style: AppTextStyles.w500.copyWith(
              fontSize: 18.0,
              color: Styles.HEADER,
            ),
          ), Text(
            getTranslated(
                "Submit_sucess_note"),
            textAlign: TextAlign.center,
            style: AppTextStyles.w500.copyWith(
              fontSize: 16.0,
              color: Styles.DISABLED,
            ),
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomButton(
                  text:
                  getTranslated("next"),
                  onTap: () {

                    CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);

                  },
                ),
              ),

            ],
          )
        ]);
  }
}
