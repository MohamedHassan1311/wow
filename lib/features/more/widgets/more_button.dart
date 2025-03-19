import 'package:wow/app/core/dimensions.dart';
import 'package:flutter/material.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/custom_images.dart';

class MoreButton extends StatelessWidget {
  const MoreButton(
      {required this.title,
      required this.icon,
      this.withBottomBorder = true,
      this.onTap,
      this.action,
      this.iconColor,
      super.key});

  final String title;
  final String icon;
  final void Function()? onTap;
  final Widget? action;
  final bool withBottomBorder;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: withBottomBorder
                        ? Styles.FILL_COLOR
                        : Colors.transparent))),
        padding: EdgeInsets.symmetric(
            vertical: Dimensions.PADDING_SIZE_SMALL.h,
            horizontal: Dimensions.paddingSizeExtraSmall.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            customContainerSvgIcon(
                backGround: Styles.WHITE_COLOR,
                color: Styles.PRIMARY_COLOR,
                withShadow: true,
                width: 40.w,
                height: 40.w,
                radius: 16.w,
                padding: 10.w,
                imageName: icon),
            SizedBox(width: Dimensions.paddingSizeExtraSmall.w),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                style: AppTextStyles.w500.copyWith(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    color: Styles.SUBTITLE),
              ),
            ),
            if (action != null) ...[SizedBox(width: 12.w), action!]
          ],
        ),
      ),
    );
  }
}
