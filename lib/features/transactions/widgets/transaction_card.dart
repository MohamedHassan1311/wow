import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import 'package:flutter/material.dart';
import '../../../app/core/styles.dart';
import '../model/transactions_model.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({super.key, required this.transaction});
  final TransactionModel transaction;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (transaction.route?.type == TransactionRouteType.product &&
            transaction.route?.id != null) {

        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeMini.h),
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
            vertical: Dimensions.PADDING_SIZE_DEFAULT.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.w),
          color: Styles.WHITE_COLOR,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              spreadRadius: 0,
              blurRadius: 5,
              offset: const Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            // customImageIconSVG(
            //   imageName: transaction.type == TransactionType.deposit
            //       ? SvgImages.deposit
            //       : SvgImages.withdraw,
            //   width: 50.w,
            //   height: 50.w,
            // ),
            SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "#${transaction.id ?? "num"}",
                          style: AppTextStyles.w600
                              .copyWith(fontSize: 16, color: Styles.PRIMARY_COLOR),
                        ),
                      ),
                      Text(
                        " ${(transaction.amount ?? 0).toStringAsFixed(2)}",
                        textAlign: TextAlign.end,
                        style: AppTextStyles.w600.copyWith(
                            fontSize: 14,
                            color:Styles.ACTIVE
                             ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          transaction.title ?? "Title",
                          style: AppTextStyles.w400
                              .copyWith(fontSize: 14, color: Styles.HEADER),
                        ),
                      ),
                      Text(
                        transaction.createAt ?? "",
                        textAlign: TextAlign.end,
                        style: AppTextStyles.w400.copyWith(
                            fontSize: 14, color: Styles.DETAILS_COLOR),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
