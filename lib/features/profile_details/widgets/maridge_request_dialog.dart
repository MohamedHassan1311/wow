import 'package:flutter/material.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/components/custom_images.dart';

import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../navigation/custom_navigation.dart';

class MaridgeRequestDialog extends StatefulWidget {
  final String name;
  final String discription;
  final String? note;
  final String image;
  final String? confirmButtonText;
  final String? backButtonText;
  final bool? showBackButton;
  final bool? showTextFeild;
  const MaridgeRequestDialog(
      {super.key,
      required this.discription,
      required this.image,
      required this.name,
      this.confirmButtonText,
      this.backButtonText,
      this.note,
      this.showBackButton = true,
      this.showTextFeild = false});

  @override
  State<MaridgeRequestDialog> createState() => _MaridgeRequestDialogState();
}

class _MaridgeRequestDialogState extends State<MaridgeRequestDialog> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose(); // مهم لتنظيف الذاكرة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      customContainerSvgIcon(
        imageName: widget.image,
        color: Styles.BLACK,
        backGround: Colors.transparent,
        width: 80.w,
        height: 80.w,
        padding: 10.w,
      ),
      SizedBox(height: 30.h),
      Text(
        widget.name,
        //  getTranslated(
        //  "marige_request"),
        style: AppTextStyles.w800.copyWith(
          fontSize: 16.0,
          color: Styles.HEADER,
        ),
      ),
      SizedBox(height: 10.h),
      Text(
        widget.discription,
        textAlign: TextAlign.center,
        style: AppTextStyles.w500.copyWith(
          fontSize: 16.0,
          color: Styles.HEADER,
        ),
      ),
      if (widget.note != null)
        Text(
          widget.note!,
          style: AppTextStyles.w500.copyWith(
            fontSize: 16.0,
            color: Styles.ERORR_COLOR,
          ),
        ),
      if (widget.showTextFeild == true)
        CustomTextField(
          controller: _messageController,
          label: getTranslated("message"),
          hint: "${getTranslated("enter")} ${getTranslated("message")}",
          inputType: TextInputType.text,
          pSvgIcon: SvgImages.user,
        ),
      SizedBox(height: 30.h),
      Row(
        spacing: 10,
        children: [
          Expanded(
            child: CustomButton(
              text: widget.confirmButtonText ?? getTranslated("confirm"),
              onTap: () {
                CustomNavigator.pop(result:_messageController.text.trim().isNotEmpty?_messageController.text.trim(): true);
              },
            ),
          ),
          if (widget.showBackButton != null && widget.showBackButton == true)
            Expanded(
              child: CustomButton(
                text: widget.backButtonText ?? getTranslated("back_off"),
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
