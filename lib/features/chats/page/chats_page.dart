import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/features/chats/bloc/chats_bloc.dart';
import 'package:wow/features/chats/repo/chats_repo.dart';
import 'package:wow/main_models/search_engine.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("chats")),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => ChatsBloc(
            repo: sl<ChatsRepo>(),
            internetConnection: sl<InternetConnection>(),
          ),
          // ..add(Click(arguments: SearchEngine())),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatsBloc, AppState>(
                  builder: (context, state) {
                    if (state is Loading) {
                      return ListAnimator(
                        customPadding: EdgeInsets.symmetric(
                            horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                        data: List.generate(
                            8, (index) => const _LoadingShimmerWidget()),
                      );
                    }
                    if (state is Done) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<ChatsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                controller:
                                    context.read<ChatsBloc>().controller,
                                customPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                data: state.cards,
                              ),
                            ),
                            CustomLoadingText(
                              loading: state.loading,
                            ),
                          ],
                        ),
                      );
                    }
                    if (state is Error || state is Empty) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<ChatsBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                customPadding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
                                  vertical: Dimensions.PADDING_SIZE_DEFAULT.h,
                                ),
                                data: [
                                  SizedBox(
                                    height: 50.h,
                                  ),
                                  EmptyState(
                                    txt: state is Error
                                        ? getTranslated("something_went_wrong")
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LoadingShimmerWidget extends StatelessWidget {
  const _LoadingShimmerWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
      ),
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.PADDING_SIZE_DEFAULT.w,
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Styles.BORDER_COLOR))),
      child: Row(
        children: [
          CustomShimmerCircleImage(
            diameter: 50.w,
          ),
          SizedBox(width: 12.w),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomShimmerContainer(
                width: 100.w,
                height: 18,
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  CustomShimmerContainer(
                    width: 120.w,
                    height: 14,
                  ),
                  SizedBox(width: 16.h),
                  CustomShimmerContainer(
                    width: 80.w,
                    height: 14,
                  ),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}
