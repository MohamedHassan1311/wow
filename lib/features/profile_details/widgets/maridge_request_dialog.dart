import 'package:flutter/material.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/components/custom_images.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_button.dart';
import '../../../navigation/custom_navigation.dart';

class MaridgeRequestDialog extends StatelessWidget {
  const MaridgeRequestDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          customContainerSvgIcon(
            imageName: SvgImages.ring,
            color: Styles.BLACK,
            backGround: Colors.transparent,
            
            width: 80.w,
            height: 80.w,
            padding: 10.w,
          ),
          SizedBox(height: 30.h),
           Text(
             getTranslated(
                 "marige_request"),
             style: AppTextStyles.w800.copyWith(
               fontSize: 16.0,
               color: Styles.HEADER,
             ),
           ),
                     SizedBox(height: 10.h),

          Text(
            getTranslated(
                "marige_request_desc"),
            style: AppTextStyles.w500.copyWith(
              fontSize: 16.0,
              color: Styles.HEADER,
            ),
          ),
                    SizedBox(height: 30.h),

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
