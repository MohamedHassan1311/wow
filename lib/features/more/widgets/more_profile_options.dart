import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/features/more/widgets/turn_button.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../notifications/bloc/turn_notification_bloc.dart';
import '../../notifications/repo/notifications_repo.dart';
import '../../personal_info/page/PersonalInfo.dart';
import 'more_button.dart';

class MoreProfileOptions extends StatelessWidget {
  const MoreProfileOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
        vertical: Dimensions.paddingSizeMini.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeExtraSmall.w,
        vertical: Dimensions.paddingSizeExtraSmall.h,
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
          ///Profile
          MoreButton(
            title: getTranslated("profile", context: context),
            icon: SvgImages.profileIcon,
            onTap: () => CustomNavigator.push(Routes.editProfile),
          ),

          ///Chats
          MoreButton(
            title: getTranslated("chats", context: context),
            icon: SvgImages.chats,
            // onTap: () => CustomNavigator.push(Routes.chats),
          ),

            ///favourit
            MoreButton(
              title: getTranslated("favourit", context: context),
              icon: SvgImages.star,
              onTap: () => CustomNavigator.push(Routes.favouritPage),
            ),


          ///blocked
          MoreButton(
            title: getTranslated("blocked_users", context: context),
            icon: SvgImages.report,
            onTap: () => CustomNavigator.push(Routes.blockPage),
          ),

          ///wallet
          MoreButton(
            title: getTranslated("wallet", context: context),
            icon: SvgImages.wallet,
            onTap: () => CustomNavigator.push(Routes.wallet),
          ),

          ///subscription
          // MoreButton(
          //   title: getTranslated("subscription", context: context),
          //   icon: SvgImages.orders,
          //   onTap: () => CustomNavigator.push(Routes.subscriptions),
          // ),

          ///subscription
          // MoreButton(
          //   title: getTranslated("payments", context: context),
          //   icon: SvgImages.saudiRiyalSymbol,
          //   onTap: () => CustomNavigator.push(Routes.transactions),
          // ),

          MoreButton(
            title: getTranslated("plans", context: context),
            icon: SvgImages.category,
            onTap: () => CustomNavigator.push(Routes.plans),
          ),
          MoreButton(
            title: getTranslated("settings", context: context),
            icon: SvgImages.settings,
            onTap: () => CustomNavigator.push(Routes.settings),
          ),
          // ///Language
          // const LanguageButton(),
        ],
      ),
    );
  }
}
