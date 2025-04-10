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
            onTap: () => CustomNavigator.push(Routes.chats),
          ),

          ///Addresses
          // MoreButton(
          //   title: getTranslated("addresses", context: context),
          //   icon: SvgImages.addresses,
          //   onTap: () => CustomNavigator.push(Routes.addresses),
          // ),


          ///Push Notification
          BlocProvider(
            create: (context) =>
                TurnNotificationsBloc(repo: sl<NotificationsRepo>()),
            child: BlocBuilder<TurnNotificationsBloc, AppState>(
              builder: (context, state) {
                return TurnButton(
                  title: getTranslated("push_notifications", context: context),
                  icon: SvgImages.notification,
                  bing: context.read<TurnNotificationsBloc>().isTurnOn,
                  isLoading: state is Loading,
                  onTap: () => CustomNavigator.push(Routes.notifications),
                );
              },
            ),
          ),

          // ///Language
          // const LanguageButton(),
        ],
      ),
    );
  }
}
