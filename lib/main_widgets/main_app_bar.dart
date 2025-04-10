import 'package:wow/app/core/extensions.dart';
import 'package:wow/components/custom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/features/maps/bloc/map_bloc.dart';
import 'package:wow/features/maps/repo/maps_repo.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import '../app/core/app_event.dart';
import '../app/core/text_styles.dart';
import '../components/custom_text_form_field.dart';
import '../data/config/di.dart';
import 'guest_mode.dart';
import 'profile_image_widget.dart';
import '../navigation/routes.dart';
import '../features/maps/models/location_model.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, AppState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            left: Dimensions.PADDING_SIZE_DEFAULT.w,
            right: Dimensions.PADDING_SIZE_DEFAULT.w,
            top: Dimensions.PADDING_SIZE_DEFAULT.h,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Styles.PRIMARY_COLOR.withOpacity(0.28),
                Color(0XFFFFF6F1).withOpacity(0.2),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ///Profile Image Widget
                    ProfileImageWidget(
                      withEdit: false,
                      radius: 20.w,
                      image: UserBloc.instance.user?.profileImage,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        if (UserBloc.instance.isLogin) {
                          CustomNavigator.push(Routes.editProfile);
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${getTranslated("have_a_good_day", context: context)},",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.w400
                                .copyWith(fontSize: 14, color: Styles.TITLE),
                          ),
                          Text(
                            UserBloc.instance.user?.name ?? "Guest",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.w600
                                .copyWith(fontSize: 18, color: Styles.HEADER),
                          ),
                        ],
                      ),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: customContainerSvgIcon(
                          onTap: () {
                            if (UserBloc.instance.isLogin) {
                              CustomNavigator.push(Routes.notifications);
                            } else {
                              CustomBottomSheet.show(widget: const GuestMode());
                            }
                          },
                          backGround: Styles.WHITE_COLOR,
                          color: Styles.PRIMARY_COLOR,
                          width: 40.w,
                          height: 40.w,
                          radius: 16.w,
                          padding: 10.w,
                          imageName: SvgImages.notification),
                    ),
                  ],
                ),

                ///Current Location
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 12.h),
                //   child: BlocProvider(
                //     create: (context) =>
                //         MapBloc(repo: sl<MapsRepo>())..add(Init()),
                //     child: BlocBuilder<MapBloc, AppState>(
                //       builder: (context, state) {
                //         if (state is Done) {
                //           LocationModel model = state.model as LocationModel;
                //           return Row(
                //             children: [
                //               customImageIconSVG(
                //                   width: 24.w,
                //                   height: 18.h,
                //                   imageName: SvgImages.address),
                //               SizedBox(width: 8.w),
                //               Expanded(
                //                 child: Text(
                //                   model.address ?? "",
                //                   maxLines: 1,
                //                   overflow: TextOverflow.ellipsis,
                //                   style: AppTextStyles.w400.copyWith(
                //                       fontSize: 14, color: Styles.TITLE),
                //                 ),
                //               ),
                //             ],
                //           );
                //         } else {
                //           return Row(
                //             children: [
                //               customImageIconSVG(
                //                   width: 20,
                //                   height: 20,
                //                   color: Styles.PRIMARY_COLOR,
                //                   imageName: SvgImages.location),
                //               SizedBox(width: 8.w),
                //               CustomShimmerText(width: 120.w),
                //             ],
                //           );
                //         }
                //       },
                //     ),
                //   ),
                // ),
                //
                // ///Search
                // CustomTextField(
                //   pSvgIcon: SvgImages.search,
                //   height: 40.h,
                //   hint: "${getTranslated("search")}...",
                //   readOnly: true,
                //   onTap: () => CustomNavigator.push(Routes.search),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize =>
      Size(CustomNavigator.navigatorState.currentContext!.width, 170.h);
}
