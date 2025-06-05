import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/custom_bottom_sheet.dart';
import 'package:wow/features/auth/deactivate_account/view/deactivate_account.dart';
import 'package:wow/features/more/widgets/more_button.dart';
import 'package:wow/features/setting/widgets/settings_button.dart';
import 'package:wow/main_blocs/user_bloc.dart';

import '../../../app/core/svg_images.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("settings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListAnimator(
              data: [
                MoreButton(
                  title: getTranslated("edit_profile", context: context),
                  icon: SvgImages.profileIcon,
                  onTap: () => CustomNavigator.push(Routes.editProfile),
                ),
                MoreButton(
                  title: getTranslated("change_password", context: context),
                  icon: SvgImages.profileIcon,
                  onTap: () => CustomNavigator.push(Routes.changePassword),
                ),
                MoreButton(
                  title: getTranslated("marriage_conditions", context: context),
                  icon: SvgImages.profileIcon,
                  onTap: () => CustomNavigator.push(Routes.marriageConditions),
                ),
                if (UserBloc.instance.isLogin)
                  MoreButton(
                    title: getTranslated("delete_account", context: context),
                    icon: SvgImages.trash,
                    iconColor: Styles.ERORR_COLOR,
                    withBottomBorder: false,
                    onTap: () => CustomBottomSheet.show(
                      height: 305.h,
                      widget: DeactivateAccount(),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
