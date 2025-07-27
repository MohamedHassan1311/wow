import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/svg_images.dart';
import '../../../data/config/di.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../../auth/destory_account/view/destroy_account.dart';
import '../../language/page/language_button.dart';
import '../../more/widgets/turn_button.dart';
import '../../notifications/bloc/turn_notification_bloc.dart';
import '../../notifications/repo/notifications_repo.dart';

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

                const LanguageButton(),

                ///Turn Notifications
                BlocProvider(
                  create: (context) =>
                      TurnNotificationsBloc(repo: sl<NotificationsRepo>()),
                  child: BlocBuilder<TurnNotificationsBloc, AppState>(
                    builder: (context, state) {
                      return TurnButton(
                        title: getTranslated("push_notification",
                            context: context),
                        icon: SvgImages.notification,
                        bing: context.read<TurnNotificationsBloc>().isTurnOn,
                        onTap: () {
                          context.read<TurnNotificationsBloc>().add(Turn());
                        },
                        isLoading: state is Loading,
                      );
                    },
                  ),
                ),

                if (UserBloc.instance.isLogin)
               Column(children: [

                 MoreButton(
                   title: getTranslated("freeze_account", context: context),
                   icon: SvgImages.freeze,
                   iconColor: Styles.BLUE_COLOR,
                   withBottomBorder: false,
                   onTap: () => CustomBottomSheet.show(
                     height: 305.h,
                     widget: DeactivateAccount(),
                   ),
                 ),
                 MoreButton(
                   title: getTranslated("delete_account", context: context),
                   icon: SvgImages.trash,
                   iconColor: Styles.ERORR_COLOR,
                   withBottomBorder: false,
                   onTap: () => CustomBottomSheet.show(
                     height: 305.h,
                     widget: DestroyAccount(),
                   ),
                 ),
               ],)
              ],
            ),
          )
        ],
      ),
    );
  }
}
