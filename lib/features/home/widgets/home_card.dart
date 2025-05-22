import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_images.dart';
import 'package:wow/components/custom_network_image.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/home/bloc/home_user_bloc.dart';
import 'package:wow/features/home/widgets/home_card_shimmer.dart';
import 'package:wow/features/language/bloc/language_bloc.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';

import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeUserBloc, AppState>(builder: (context, state) {
      if (state is Loading) {
        return const HomeCardShimmer();
      } else if (state is Error) {
        return EmptyState(
          txt: state is Error ? getTranslated("something_went_wrong") : null,
        );
      } else if (state is Done) {
        return InkWell(
              onTap: () {
                CustomNavigator.push(Routes.profileDetails, arguments: context.read<HomeUserBloc>().model?.id);
              },
          child: Stack(
            children: [
              CustomNetworkImage.containerNewWorkImage(
                image: context.read<HomeUserBloc>().model?.image ?? "",
                width: context.width,
                
                onTap: () {
                  CustomNavigator.push(Routes.profileDetails, arguments: context.read<HomeUserBloc>().model?.id);
                },
                defaultImage: "assets/images/imagebg.png",
                height: context.height,
                fit: BoxFit.cover,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Row(
                        spacing: 15,
                        children: [
                          Text(
                            context.read<HomeUserBloc>().model?.name ?? "",
                            style: AppTextStyles.w800.copyWith(
                                color: Styles.WHITE_COLOR, fontSize: 28),
                          ),
                          Text(
                            context.read<HomeUserBloc>().model?.age.toString() ??
                                "",
                            style: AppTextStyles.w800.copyWith(
                                color: Styles.WHITE_COLOR, fontSize: 22),
                          ),
                          if (context.read<HomeUserBloc>().model?.isVerified == 1)
                            customImageIconSVG(
                              imageName: SvgImages.verify,
                              width: 20,
                              height: 20,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT,
                      ),
                      child: Row(
                        spacing: 15,
                        children: [
                          if (context.read<HomeUserBloc>().model?.countryId !=
                              null && context.read<HomeUserBloc>().model?.countryId?.name != 'no Data')
                            Text(
                              context
                                      .read<HomeUserBloc>()
                                      .model
                                      ?.countryId
                                      ?.name ??
                                  "",
                              style: AppTextStyles.w800.copyWith(
                                  color: Styles.WHITE_COLOR, fontSize: 16),
                            ),
                          if (context.read<HomeUserBloc>().model?.cityId != null && context.read<HomeUserBloc>().model?.cityId?.name != 'no Data')
                            Text(
                              context.read<HomeUserBloc>().model?.cityId?.name ??
                                  "",
                              style: AppTextStyles.w800.copyWith(
                                  color: Styles.WHITE_COLOR, fontSize: 16),
                            ),
                        ],
                      ),
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: [
                        if (context.read<HomeUserBloc>().model?.education !=
                                null &&
                            context.read<HomeUserBloc>().model?.education?.name !=
                                'no Data')
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  context
                                          .read<HomeUserBloc>()
                                          .model
                                          ?.education
                                          ?.name ??
                                      "",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )),
                        if (context.read<HomeUserBloc>().model?.tribe != null &&
                            context.read<HomeUserBloc>().model?.tribe?.name !=
                                'no Data')
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  context
                                          .read<HomeUserBloc>()
                                          .model
                                          ?.tribe
                                          ?.name ??
                                      "",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )),
                        if (context.read<HomeUserBloc>().model?.skinColor !=
                                null &&
                            context.read<HomeUserBloc>().model?.skinColor?.name !=
                                'no Data')
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Text(
                                  context
                                          .read<HomeUserBloc>()
                                          .model
                                          ?.skinColor
                                          ?.name ??
                                      "",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.PADDING_SIZE_DEFAULT),
                      child: Row(
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                        child: Dismissible(
                                      key: Key('unique_key'),
                                      direction: DismissDirection
                                          .startToEnd, // 👈 Only allow swipe left
          
                                      confirmDismiss: (direction) async {
                                        sl<FavouritBloc>().add(Add(arguments: context.read<HomeUserBloc>().model?.id));
          
          
                                        // ❗ Prevent the widget from being removed
                                        return false;
                                      },
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 20),
                                        child: Icon(Icons.arrow_forward,
                                            color: Colors.white),
                                      ),
                                      secondaryBackground: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            EdgeInsets.symmetric(horizontal: 20),
                                        child: Icon(Icons.arrow_back,
                                            color: Colors.white),
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Image.asset(
                                          Images.swipeHertButton,
                                          matchTextDirection:
                                              LanguageBloc.instance.isLtr,
                                          height: 70,
                                        ),
                                      ),
                                    )),
                                    Expanded(
                                        child: Dismissible(
                                            key: Key('unique_key'),
                                            direction: DismissDirection
                                                .endToStart, // 👈 Only allow swipe left
          
                                            confirmDismiss: (direction) async {
                                              if (direction ==
                                                  DismissDirection.startToEnd) {
                                                print("Swiped Right");
                                              } else if (direction ==
                                                  DismissDirection.endToStart) {
                                                print("Swiped Left");
                                              }
                sl<HomeUserBloc>().add(Click());
          
                                              // ❗ Prevent the widget from being removed
                                              return false;
                                            },
                                            background: Container(
                                              color: Colors.redAccent,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Icon(Icons.arrow_forward,
                                                  color: Colors.white),
                                            ),
                                            secondaryBackground: Container(
                                              color: Colors.black,
                                              alignment: Alignment.centerRight,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20),
                                              child: Icon(Icons.arrow_back,
                                                  color: Colors.white),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Image.asset(
                                                    matchTextDirection:
                                                        LanguageBloc
                                                            .instance.isLtr,
                                                    Images.swipeLeft,
                                                    height: 70,
                                                  ),
                                                ),
                                              ],
                                            ))),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox();
    });
  }
}
