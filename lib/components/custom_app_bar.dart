import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import '../../navigation/custom_navigation.dart';
import '../app/core/styles.dart';
import '../app/core/text_styles.dart';
import 'back_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? actionChild;
  final bool withBack;
  final bool withHPadding;
  final bool withVPadding;
  final double? height;
  final Color? backColor;
  final double? actionWidth;
  final bool? isCenter;
  const CustomAppBar(
      {super.key,
      this.title,
      this.height,
      this.backColor,
      this.withHPadding = true,
      this.withVPadding = true,
      this.withBack = true,
      this.actionWidth,
      this.isCenter=true,
      this.actionChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: withHPadding ? Dimensions.PADDING_SIZE_DEFAULT.w : 0,
        vertical: withVPadding ? Dimensions.PADDING_SIZE_DEFAULT.h : 0,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Styles.PRIMARY_COLOR.withOpacity(0.28),
            Color(0XFFFFF6F1).withOpacity(0.2),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Row(
          spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            withBack && CustomNavigator.navigatorState.currentState!.canPop()
                ? FilteredBackIcon()
                : SizedBox(
                    width: actionWidth ?? 40.w,
                  ),
            if(isCenter==true)
            const Expanded(child: SizedBox()),
            Text(
              title ?? "",
              style: AppTextStyles.w600
                  .copyWith(color: Styles.HEADER, fontSize: 18),
            ),
            const Expanded(child: SizedBox()),
            SizedBox(
              // height: actionWidth ?? 40.w,
              width: actionWidth ?? 40.w,
              child: actionChild ?? const SizedBox(),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(
      CustomNavigator.navigatorState.currentContext!.width, height ?? 120.h);
}
