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
  final String name;
  final String discription;
  final String? note;
  final String image;
  final String? confirmButtonText;
  final String? backButtonText;
  final bool? showBackButton;
  const MaridgeRequestDialog(
      {super.key,
      required this.discription,
      required this.image,
      required this.name,
      this.confirmButtonText,
      this.backButtonText,
      this.note,
      this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      customContainerSvgIcon(
        imageName: image,
        color: Styles.BLACK,
        backGround: Colors.transparent,
        width: 80.w,
        height: 80.w,
        padding: 10.w,
      ),
      SizedBox(height: 30.h),
      Text(
        name,
        //  getTranslated(
        //  "marige_request"),
        style: AppTextStyles.w800.copyWith(
          fontSize: 16.0,
          color: Styles.HEADER,
        ),
      ),
      SizedBox(height: 10.h),
        Text(
          discription,
          textAlign: TextAlign.center,
          style: AppTextStyles.w500.copyWith(
            fontSize: 16.0,
            color: Styles.HEADER,
          ),
        ),
        if (note != null)
          Text(
            note!,
            style: AppTextStyles.w500.copyWith(
              fontSize: 16.0,
              color: Styles.ERORR_COLOR,
            ),
          ),
      SizedBox(height: 30.h),
      Row(
        spacing: 10,
        children: [
          Expanded(
            child: CustomButton(
              text: confirmButtonText ?? getTranslated("confirm"),
              onTap: () {
                CustomNavigator.pop(result: true);
              },
            ),
          ),
          if (showBackButton != null && showBackButton == true)
            Expanded(
              child: CustomButton(
                text: backButtonText ?? getTranslated("back_off"),
                backgroundColor: Colors.transparent,
                textColor: Styles.PRIMARY_COLOR,
                borderColor: Styles.PRIMARY_COLOR,
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
