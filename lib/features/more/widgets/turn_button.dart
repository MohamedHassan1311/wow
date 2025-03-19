import 'package:wow/app/core/dimensions.dart';
import 'package:flutter/material.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../components/custom_images.dart';

class TurnButton extends StatelessWidget {
  const TurnButton({
    required this.title,
    this.onTap,
    super.key,
    this.icon,
    required this.bing,
    required this.isLoading,
  });
  final String title;
  final String? icon;
  final bool bing, isLoading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // decoration: BoxDecoration(
      //     border: Border(bottom: BorderSide(color: Styles.FILL_COLOR))),
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.PADDING_SIZE_SMALL.h,
          horizontal: Dimensions.PADDING_SIZE_SMALL.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Visibility(
            visible: icon != null,
            child: customContainerSvgIcon(
                backGround: Styles.WHITE_COLOR,
                color: Styles.PRIMARY_COLOR,
                withShadow: true,
                width: 40.w,
                height: 40.w,
                radius: 16.w,
                padding: 10.w,
                imageName: icon!),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Text(
                title,
                maxLines: 1,
                style: AppTextStyles.w500.copyWith(
                    fontSize: 16,
                    overflow: TextOverflow.ellipsis,
                    color: Styles.SUBTITLE),
              ),
            ),
          ),
          SizedBox(
            height: 10,
            child: Switch(
              value: bing,
              inactiveThumbColor: Styles.WHITE_COLOR,
              inactiveTrackColor: Styles.BORDER_COLOR,
              onChanged: (v) {
                onTap?.call();
              },
              trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
                  (Set<WidgetState> states) {
                return bing ? Styles.PRIMARY_COLOR : Styles.BORDER_COLOR;
              }),
              trackOutlineWidth: WidgetStateProperty.resolveWith<double?>(
                  (Set<WidgetState> states) {
                return 1.0;
              }),
            ),
          )
        ],
      ),
    );
  }
}
