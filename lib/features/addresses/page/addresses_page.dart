import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/svg_images.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_app_bar.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/features/addresses/bloc/addresses_bloc.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';
import 'package:wow/features/addresses/widgets/address_card.dart';
import 'package:wow/main_models/search_engine.dart';

import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_images.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/internet_connection.dart';
import '../../../navigation/custom_navigation.dart';
import '../../../navigation/routes.dart';
import '../repo/addresses_repo.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getTranslated("addresses")),
      floatingActionButton: customContainerSvgIcon(
          onTap: () => CustomNavigator.push(Routes.addAddress),
          backGround: Styles.PRIMARY_COLOR,
          color: Styles.WHITE_COLOR,
          width: 50.w,
          height: 50.w,
          radius: 16.w,
          padding: 12.w,
          imageName: SvgImages.add),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => AddressesBloc(
            repo: sl<AddressesRepo>(),
            internetConnection: sl<InternetConnection>(),
          )..add(Click(arguments: SearchEngine())),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<AddressesBloc, AppState>(
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
                      List<AddressModel> addresses =
                          state.list as List<AddressModel>;
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<AddressesBloc>()
                              .add(Click(arguments: SearchEngine()));
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: ListAnimator(
                                controller:
                                    context.read<AddressesBloc>().controller,
                                customPadding: EdgeInsets.symmetric(
                                    horizontal:
                                        Dimensions.PADDING_SIZE_DEFAULT.w),
                                data: List.generate(
                                  addresses.length,
                                  (i) => AddressCard(address: addresses[i]),
                                ),
                              ),
                            ),
                            CustomLoadingText(loading: state.loading),
                          ],
                        ),
                      );
                    }
                    if (state is Error || state is Empty) {
                      return RefreshIndicator(
                        color: Styles.PRIMARY_COLOR,
                        onRefresh: () async {
                          context
                              .read<AddressesBloc>()
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
                                  SizedBox(height: 100.h),
                                  EmptyState(
                                    isSvg: true,
                                    img: SvgImages.address,
                                    imgHeight: context.width * 0.5,
                                    imgWidth: context.width * 0.4,
                                    txt: getTranslated(
                                      (state is Error)
                                          ? "something_went_wrong"
                                          : "you_have_no_added_addresses",
                                    ),
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
