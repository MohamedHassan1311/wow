import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_core.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/custom_loading_text.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/features/subscription/repo/subscription_repo.dart';
import 'package:wow/main_models/search_engine.dart';
import '../bloc/subscription_bloc.dart';

import '../model/subscription_model.dart';

// ignore: must_be_immutable
class SubscriptionPage extends StatelessWidget {
  SubscriptionPage({Key? key}) : super(key: key);

  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SubscriptionBloc(repo: sl<SubscriptionRepo>()),
        child: Scaffold(
          // appBar: CustomAppBar(
          //   title: getTranslated("subscription"),
          // ),
          body: SafeArea(
            child: BlocProvider(
              create: (context) =>
                  SubscriptionBloc(repo: sl<SubscriptionRepo>())
                    ..add(Click(arguments: SearchEngine())),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: BlocBuilder<SubscriptionBloc, AppState>(
                      builder: (context, state) {
                        if (state is Loading) {
                          return ListAnimator(
                            customPadding: EdgeInsets.symmetric(
                                horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                            data: List.generate(
                              10,
                              (i) => Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.paddingSizeMini.h),
                                child: CustomShimmerContainer(
                                  height: 100.h,
                                  width: context.width,
                                  radius: 12.w,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is Done) {
                          List<SubscriptionModel> list =
                              state.list as List<SubscriptionModel>;
                          return RefreshIndicator(
                            color: Styles.PRIMARY_COLOR,
                            onRefresh: () async {
                              context
                                  .read<SubscriptionBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListAnimator(
                                    controller: controller,
                                    customPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_DEFAULT.w),
                                    data: List.generate(
                                      list.length,
                                      (i) => SubscriptionCard(
                                        subscription: list[i],
                                      ),
                                    ),
                                  ),
                                ),
                                CustomLoadingText(loading: state.loading),
                              ],
                            ),
                          );
                        }
                        if (state is Empty || State is Error) {
                          return RefreshIndicator(
                            color: Styles.PRIMARY_COLOR,
                            onRefresh: () async {
                              context
                                  .read<SubscriptionBloc>()
                                  .add(Click(arguments: SearchEngine()));
                            },
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListAnimator(
                                    customPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.PADDING_SIZE_DEFAULT.w),
                                    data: [
                                      SizedBox(
                                        height: 50.h,
                                      ),
                                      EmptyState(
                                        img: Images.emptyTransactions,
                                        imgHeight: 220.h,
                                        imgWidth: 220.w,
                                        txt: state is Error
                                            ? getTranslated(
                                                "something_went_wrong")
                                            : null,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SubscriptionCard extends StatelessWidget {
  final SubscriptionModel subscription;

  const SubscriptionCard({
    Key? key,
    required this.subscription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: context.width,
        decoration: BoxDecoration(
          color: Styles.PRIMARY_COLOR.withOpacity(.01),
          borderRadius: BorderRadius.circular(12.w),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: context.width,
                child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      subscription.name,
                      style: AppTextStyles.w900.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: Styles.PRIMARY_COLOR),
                    ),
                
                    Text(
                      getTranslated(subscription.isActive?"active":"inactive"),
                      style: AppTextStyles.w300.copyWith(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          color: subscription.isActive?Styles.ACTIVE:Styles.IN_ACTIVE),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subscription.endDate.dateTimeFormatChat(),
                style: AppTextStyles.w400.copyWith(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    color: Styles.DETAILS_COLOR),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '${subscription.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  AppCore.saudiRiyalSymbol()
                ],
              ),
              const SizedBox(height: 8),
              // Text('Duration: ${subscription.duration} days'),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
