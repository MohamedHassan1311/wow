import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_network_image.dart';
import '../../../app/core/styles.dart';
import '../model/categories_model.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard(
      {super.key, this.height, this.width, this.fontSize, required this.model});
  final CategoryModel model;
  final double? width, height, fontSize;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRect(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomNetworkImage.containerNewWorkImage(
                  image: model.image ?? "",
                  width: width ?? 80.w,
                  height: height ?? 80.w,
                  radius: 20.w,
                  borderColor: Styles.LIGHT_BORDER_COLOR,
                ),
                if (model.isComingSoon == true)
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: width ?? 80.w,
                      height: height ?? 80.w,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: Styles.LIGHT_BORDER_COLOR),
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.black.withOpacity(0.2)),
                      child: Text(
                        getTranslated("coming_soon"),
                        textAlign: TextAlign.center,
                        style: AppTextStyles.w600.copyWith(
                            fontSize: ((fontSize ?? 14) - 2),
                            color: Styles.WHITE_COLOR),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            model.name ?? "Small animal",
            style: AppTextStyles.w600
                .copyWith(fontSize: fontSize ?? 14, color: Styles.HEADER),
          ),
        ],
      ),
    );
  }
}
