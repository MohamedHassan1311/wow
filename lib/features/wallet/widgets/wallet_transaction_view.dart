import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_loading_text.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/features/transactions/bloc/transactions_bloc.dart';
import 'package:wow/features/transactions/model/transactions_model.dart';
import 'package:wow/features/transactions/widgets/transaction_card.dart';
import 'package:wow/features/wallet/bloc/wallet_bloc.dart';
import 'package:wow/features/wallet/model/wallet_model.dart';
import 'package:wow/main_models/search_engine.dart';

class WalletTransactionView extends StatelessWidget {
  const WalletTransactionView({super.key});

  @override
  Widget build(BuildContext context) {
 context.read<WalletBloc>() ..add(Click(arguments: SearchEngine()));
    return       BlocBuilder<WalletBloc, AppState>(
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
          TransactionsModel? list =
              context.read<WalletBloc>().model;
          return RefreshIndicator(
            color: Styles.PRIMARY_COLOR,
            onRefresh: () async {
              context
                  .read<WalletBloc>()
                  .add(Click(arguments: SearchEngine()));
            },
            child: Column(
              children: [
                Expanded(
                  child: ListAnimator(
                    controller:    context
                  .read<WalletBloc>().controller,
                    customPadding: EdgeInsets.symmetric(
                        horizontal:
                            Dimensions.PADDING_SIZE_DEFAULT.w),
                    data: List.generate(
                      list?.data?.length ?? 0,
                      (i) => TransactionCard(
                        transaction: list?.data?[i] ?? TransactionModel(),
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
                  .read<TransactionsBloc>()
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
                        imgHeight: 220.h,
                        imgWidth: 220.w,
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
        }
        return const SizedBox();
      },
    )
             ;
  }
}
