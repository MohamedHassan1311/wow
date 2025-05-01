import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import '../app/localization/language_constant.dart';
import '../navigation/custom_navigation.dart';
import 'custom_button.dart';

abstract class CustomAlertDialog {


  static show(
      {dailog}) {
    return showDialog(
      context: CustomNavigator.navigatorState.currentContext!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return dailog ;

      },
    );
  }
}
