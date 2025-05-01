import 'package:flutter/material.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_button.dart';
import '../../../navigation/custom_navigation.dart';

class SubmitConfirmationDialog extends StatelessWidget {
  const SubmitConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Dimensions
                  .PADDING_SIZE_DEFAULT.w *
                  2,
            ),
            child: Text(
              getTranslated(
                  "Are_you_sure_the_data_is_correct?"),
              style: AppTextStyles.w500.copyWith(
                fontSize: 16.0,
                color: Styles.HEADER,
              ),
            ),
          ),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: CustomButton(
                    text:
                    getTranslated("confirm"),
                    onTap: () {

                      CustomNavigator.pop(result: true);

                    },
                    ),
              ),
              Expanded(
                child: CustomButton(
                  text: getTranslated("back_off"),
                  backgroundColor:
                  Colors.transparent,
                  textColor: Styles.PRIMARY_COLOR,
                  borderColor:
                  Styles.PRIMARY_COLOR,
                  withBorderColor: true,
                  onTap: () {
                    CustomNavigator.pop(result: false);
                  },
                ),
              ),
            ],
          )
        ]);
  }
}
