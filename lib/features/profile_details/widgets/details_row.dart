import 'package:flutter/material.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';

class DetailsRow extends StatelessWidget {
  const DetailsRow({super.key, required this.title, required this.value,  this.textColor});
  final String title;
  final String value;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style:  AppTextStyles.w600.copyWith(fontSize: 16, color:textColor?? Styles.HEADER))),
                    Expanded(child: Text(getTranslated(value), style:  AppTextStyles.w400.copyWith(fontSize: 16, color: Styles.HEADER))),

        ],
      ),
    );
  }

}
