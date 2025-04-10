import 'package:flutter/material.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/localization/language_constant.dart';
import '../../app/core/styles.dart';
import '../../app/core/svg_images.dart';
import '../bloc/dashboard_bloc.dart';
import 'nav_bar_item.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: DashboardBloc.instance.selectIndexStream,
        builder: (context, snapshot) {
          return Container(
            width: context.width,
            padding: EdgeInsets.only(
              left: 8.w,
              right: 8.w,
              bottom: 8.h,
            ),
            decoration: BoxDecoration(
                color: Styles.WHITE_COLOR,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      offset: const Offset(0, -1),
                      spreadRadius: 1,
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                )),
            child: SafeArea(
              top: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("Compatibility", context: context),
                        svgIcon: SvgImages.users,
                        isSelected: (snapshot.data ?? 0) == 0,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(0);
                        }),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("favourites", context: context),
                        svgIcon: SvgImages.fav,
                        isSelected: (snapshot.data ?? 0) == 1,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(1);
                        }),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("Marriage requests", context: context),
                        imageIcon: Images.logoWord,
                        isSelected: (snapshot.data ?? 0) == 2,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(2);
                        }),
                  ),  Expanded(
                    child: BottomNavBarItem(
                        label: getTranslated("messages", context: context),
                        svgIcon: SvgImages.chats,
                        isSelected: (snapshot.data ?? 0) == 3,
                        onTap: () {
                          DashboardBloc.instance.updateSelectIndex(3);
                        }),
                  ),
                  Expanded(
                    child: BottomNavBarItem(
                      label: getTranslated("more", context: context),
                      svgIcon: SvgImages.settings,
                      isSelected: (snapshot.data ?? 0) == 4,
                      onTap: () {
                        DashboardBloc.instance.updateSelectIndex(4);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
