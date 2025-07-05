import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/components/custom_bottom_sheet.dart';
import 'package:wow/features/more/widgets/turn_button.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../auth/deactivate_account/view/deactivate_account.dart';
import '../../auth/logout/view/logout_button.dart';
import '../../language/page/language_button.dart';
import '../../notifications/bloc/turn_notification_bloc.dart';
import '../../notifications/repo/notifications_repo.dart';
import 'more_button.dart';

class MoreSettingsOptions extends StatelessWidget {
  const MoreSettingsOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
        // vertical: Dimensions.paddingSizeMini.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeExtraSmall.w,
        // vertical: Dimensions.paddingSizeExtraSmall.h,
      ),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
          // side: BorderSide(
          //   color: Styles.FILL_COLOR
          // )
        ),
      ),
      child: Column(
        children: [

 ///Terms && Conditions
          // MoreButton(
          //   title: getTranslated("marie_terms", context: context),
          //   icon: SvgImages.terms,
          //   onTap: () => CustomNavigator.push(Routes.terms),
          // ),

          ///Terms && Conditions
          MoreButton(
            title: getTranslated("terms_conditions", context: context),
            icon: SvgImages.terms,
            onTap: () => CustomNavigator.push(Routes.terms),
          ),

          ///Privacy && Policy
          MoreButton(
            title: getTranslated("privacy_policy", context: context),
            icon: SvgImages.privacyPolicy,
            onTap: () => CustomNavigator.push(Routes.privacy),
          ),


          ///Contact With Us
          // MoreButton(
          //   title: getTranslated("contact_with_us", context: context),
          //   icon: SvgImages.contactWithUs,
          //   onTap: () => CustomNavigator.push(Routes.contactWithUs),
          // ),



          const LogOutButton(),
        ],
      ),
    );
  }
}
