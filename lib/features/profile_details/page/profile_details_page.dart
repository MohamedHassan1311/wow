import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/back_icon.dart';
import 'package:wow/components/custom_alert_dialog.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/features/profile_details/repo/profile_details_repo.dart';
import 'package:wow/features/profile_details/widgets/maridge_request_dialog.dart';
import 'package:wow/features/profile_details/widgets/personal_image.dart';
import 'package:wow/features/profile_details/widgets/personal_info_country.dart';
import 'package:wow/features/profile_details/widgets/personal_info_education.dart';
import 'package:wow/features/profile_details/widgets/personal_info_maridge_info.dart';
import 'package:wow/features/profile_details/widgets/personal_info_sect_and_tribe.dart'
    show PersonalInfoTapSectAndTribe;
import 'package:wow/features/profile_details/widgets/personal_info_tap.dart';
import 'package:wow/features/profile_details/widgets/profile_loading.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/styles.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/grid_list_animator.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../bloc/profile_details_bloc.dart';
import '../model/categories_model.dart';

class ProfileDetailsPage extends StatefulWidget {
  const ProfileDetailsPage({super.key, this.profileDetailsId});
  final int? profileDetailsId;

  @override
  State<ProfileDetailsPage> createState() => _ProfileDetailsPageState();
}

class _ProfileDetailsPageState extends State<ProfileDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ProfileDetailsBloc(
              internetConnection: sl<InternetConnection>(),
              repo: sl<ProfileDetailsRepo>())
            ..add(Click(arguments: widget.profileDetailsId)),
          child: DefaultTabController(
            length: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.PADDING_SIZE_DEFAULT),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT.h),
                  Expanded(
                    child: BlocBuilder<ProfileDetailsBloc, AppState>(
                      builder: (context, state) {
                        if (state is Loading) {
                          return ProfileDetailsShimmer();
                        }
                        if (state is Done) {
                          final user = state.data as UserModel;
                          return RefreshIndicator(
                            color: Styles.PRIMARY_COLOR,
                            onRefresh: () async {
                              context.read<ProfileDetailsBloc>().add(
                                    Click(arguments: widget.profileDetailsId),
                                  );
                            },
                            child: NestedScrollView(
                              headerSliverBuilder:
                                  (context, innerBoxIsScrolled) => [
                                SliverAppBar(
                                  backgroundColor: Colors.white,
                                  expandedHeight: context.height * .45,
                                  pinned: true,
                                  automaticallyImplyLeading: false,
                                  flexibleSpace: LayoutBuilder(
                                    builder: (BuildContext context,
                                        BoxConstraints constraints) {
                                      bool collapsed =
                                          constraints.maxHeight < 120;

                                      return FlexibleSpaceBar(
                                        centerTitle: true,
                                        title: collapsed
                                            ? Text(
                                                user.name ?? "",
                                                style: const TextStyle(
                                                    color: Colors.black),
                                              )
                                            : null,
                                        background: PersonalImage(
                                          user: user,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SliverPersistentHeader(
                                  pinned: true,
                                  delegate: _SliverTabBarDelegate(
                                    TabBar(
                                      labelColor: Styles.PRIMARY_COLOR,
                                      unselectedLabelColor: Styles.BLACK,
                                      isScrollable: true,
                                      indicatorColor: Styles.PRIMARY_COLOR,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      tabAlignment: TabAlignment.start,
                                      tabs: [
                                        Tab(
                                            text: getTranslated(
                                                "personal_information")),
                                        Tab(
                                            text: getTranslated(
                                                "Sect and tribe")),
                                        Tab(text: getTranslated("nationality")),
                                        Tab(text: getTranslated("education")),
                                        Tab(text: getTranslated("marriage_conditions")),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              body: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  TabBarView(
                                    children: [
                                      PersonalInfoTap(user: user),
                                      PersonalInfoTapSectAndTribe(user: user),
                                      PersonalInfoTapCountry(user: user),
                                      PersonalInfoTapEducation(user: user),
                                      PersonalInfoMaridgeInfo(user: user),
                                    ],
                                  ),

                                  Positioned(
                                    bottom: 0,
                                    width: context.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        if(user.isIntersted==1)
                                        customImageIconSVG(
                                          imageName: SvgImages.removeInterset,
                                          onTap: () {


                                            {
                                               context
                                                .read<InterestBloc>()
                                                .add(Delete(
                                                    arguments: user.id! ));
                                               setState(() {
                                                 user.isIntersted=0;
                                               });
                                            }
                                            // else
                                            // {
                                            //   context
                                            //     .read<ProfileDetailsBloc>()
                                            //     .add(Click(
                                            //         arguments: user.id! + 1));
                                            // }
                                            //
                                            // context
                                            //     .read<ProfileDetailsBloc>()
                                            //     .add(Click(
                                            //         arguments: user.id! + 1));
                                          },
                                          width: 45.w,
                                          height: 45.h,
                                        ),
                                               if(user.isIntersted==0)
                                        customImageIconSVG(
                                          onTap: () {
                                            sl
                                                .get<InterestBloc>()
                                                .add(Add(arguments: user.id));

                                            // setState(() {
                                            //   user.isIntersted=1;
                                            // });

                                            // context
                                            //     .read<ProfileDetailsBloc>()
                                            //     .add(Click(
                                            //         arguments: user.id! + 1));
                                          },
                                          imageName: SvgImages.interset,
                                          width: 60.w,
                                          height: 60.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        if (state is Error || state is Empty) {
                          return RefreshIndicator(
                            color: Styles.PRIMARY_COLOR,
                            onRefresh: () async {
                              context.read<ProfileDetailsBloc>().add(
                                    Click(
                                      arguments: widget.profileDetailsId! + 1,
                                    ),
                                  );
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListAnimator(
                                    customPadding: EdgeInsets.symmetric(
                                        vertical:
                                            Dimensions.PADDING_SIZE_DEFAULT.h),
                                    data: [
                                      SizedBox(height: 50.h),
                                      EmptyState(
                                          txt: state is Error
                                              ? getTranslated(
                                                  "something_went_wrong")
                                              : null),
                                      CustomButton(
                                        onTap: () {
                                          context
                                              .read<ProfileDetailsBloc>()
                                              .add(Click(
                                                  arguments:
                                                      widget.profileDetailsId! + 10));
                                        },
                                        text: getTranslated("retry"),
                                        backgroundColor: Styles.PRIMARY_COLOR,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return RefreshIndicator(
                            color: Styles.PRIMARY_COLOR,
                            onRefresh: () async {},
                            child: Column(
                              children: [],
                            ),
                          );
                          return const SizedBox();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white, // Keeps tab bar visible
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
