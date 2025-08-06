import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';

class ChooesCountryDialog extends StatelessWidget {
  final Function(String selectedCountry) onCountrySelected;

  const ChooesCountryDialog({
    super.key,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              getTranslated("choose_country", ),
              style: AppTextStyles.w900.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.h),

            /// Saudi Arabia Option
            _buildOption(
              context,
              icon: "SA",
              label: getTranslated("saudi_arabia", ),
              onTap: () => onCountrySelected("SA"),
            ),
            SizedBox(height: 12.h),

            /// Global Option
            _buildOption(
              context,
              icon: "global",
              label: getTranslated("global", ),
              onTap: () => onCountrySelected("GLOBAL"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context,
      {required String icon,
        required String label,
        required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Styles.LIGHT_BORDER_COLOR,
          border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
        ),
        child: Row(
          children: [
            Text(
              '${icon.toFlagEmoji ?? ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.w600.copyWith(
                color: Styles.BLACK,
                fontSize: 12,
              ),
            ),

            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.w900,
              ),
            ),
            Icon(Icons.chevron_right, color: Styles.DISABLED),
          ],
        ),
      ),
    );
  }
}
