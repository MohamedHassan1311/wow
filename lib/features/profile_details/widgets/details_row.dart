import 'package:flutter/material.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';

class DetailsRow extends StatelessWidget {
  const DetailsRow({super.key, required this.title, required this.value});
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style:  AppTextStyles.w600.copyWith(fontSize: 16, color: Styles.HEADER))),
                    Expanded(child: Text(value, style:  AppTextStyles.w400.copyWith(fontSize: 16, color: Styles.HEADER))),

        ],
      ),
    );
  }
   
}