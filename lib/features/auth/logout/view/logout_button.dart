import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/features/auth/logout/view/logout_view.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../../app/core/dimensions.dart';
import '../../../../app/core/styles.dart';
import '../../../../app/core/svg_images.dart';
import '../../../../app/core/text_styles.dart';
import '../../../../app/localization/language_constant.dart';
import '../../../../components/custom_bottom_sheet.dart';
import '../../../../components/custom_images.dart';
import '../../../../data/config/di.dart';
import '../bloc/logout_bloc.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LogoutBloc, AppState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (sl<LogoutBloc>().isLogin) {
              CustomBottomSheet.show(
                height: 300.h,
                widget: LogoutView(),
              );
            } else {
              CustomNavigator.push(Routes.login);
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: Dimensions.PADDING_SIZE_SMALL.h,
                horizontal: Dimensions.PADDING_SIZE_SMALL.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                customContainerSvgIcon(
                  backGround: Styles.WHITE_COLOR,
                  color: sl<LogoutBloc>().isLogin
                      ? Styles.ERORR_COLOR
                      : Styles.ACTIVE,
                  withShadow: true,
                  width: 40.w,
                  height: 40.w,
                  radius: 16.w,
                  padding: 10.w,
                  imageName: sl<LogoutBloc>().isLogin
                      ? SvgImages.logout
                      : SvgImages.login,
                ),
                SizedBox(width: 8.w),
                state is Loading
                    ? const SpinKitThreeBounce(
                        color: Styles.ERORR_COLOR, size: 25)
                    : Flexible(
                        child: Text(
                            getTranslated(
                                sl<LogoutBloc>().isLogin ? "logout" : "login",
                                context: context),
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.w500.copyWith(
                                fontSize: 16,
                                overflow: TextOverflow.ellipsis,
                                color: sl<LogoutBloc>().isLogin
                                    ? Styles.ERORR_COLOR
                                    : Styles.ACTIVE)),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
