import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/dimensions.dart';

import '../../../app/core/app_state.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/svg_images.dart';
import '../../../components/custom_bottom_sheet.dart';
import '../../../components/custom_images.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/guest_mode.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../bloc/notifications_bloc.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: BlocBuilder<NotificationsBloc, AppState>(
          builder: (context, state) {
            return Badge(
              position: BadgePosition.topEnd(top: -5, end: -5),
              badgeContent: Text(
                context.read<NotificationsBloc>().res?.unreadCount??"",  // The count to show
                style: TextStyle(color: Colors.white),
              ),
              child: customContainerSvgIcon(
                  onTap: () {
                    if (UserBloc.instance.isLogin) {
                      CustomNavigator.push(
                          Routes.notifications);
                    } else {
                      CustomBottomSheet.show(
                          widget: const GuestMode());
                    }
                  },
                  backGround: Styles.WHITE_COLOR,
                  color: Styles.PRIMARY_COLOR,
                  width: 30.w,
                  height: 30.w,
                  radius: 16.w,
                  padding: 5.w,
                  imageName: SvgImages.notification),
            );
          }
      ),
    );
  }
}
