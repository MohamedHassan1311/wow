import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wow/app/core/dimensions.dart';
import '../../navigation/custom_navigation.dart';
import '../app/core/images.dart';
import '../app/core/styles.dart';
import 'custom_images.dart';

abstract class CustomSimpleDialog {
  static parentSimpleDialog(
      {required Widget customWidget,
        String? icon,
        bool withContentPadding = true,
        bool coverAllPage = false,
        bool canDismiss = true}) {
    return showGeneralDialog(
        barrierColor: Colors.black.withValues(alpha: 0.8),
        barrierDismissible: canDismiss,
        barrierLabel: '',
        context: CustomNavigator.navigatorState.currentContext!,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionDuration: Duration(microseconds: 0),
        transitionBuilder: (context, a1, a2, widget) {
          return SizedBox(
            child: coverAllPage
                ? customWidget
                : SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 1,
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(
                horizontal: withContentPadding
                    ? Dimensions.PADDING_SIZE_DEFAULT.w
                    : 0,
              ),
              children: [
                Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Styles.WHITE_COLOR,
                          borderRadius: BorderRadius.circular(20)),
                      padding: EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                      margin: const EdgeInsets.symmetric(vertical: 70),
                      child: customWidget,
                    ),
                    Visibility(
                        visible: icon != null,
                        child: customImageIcon(
                            imageName: (icon ?? Images.success),
                            width: 120,
                            height: 120)),
                  ],
                )
              ],
            ),
          ).animate().slideY(duration: 400.ms, curve: Curves.easeOutBack);
        });
  }
}
