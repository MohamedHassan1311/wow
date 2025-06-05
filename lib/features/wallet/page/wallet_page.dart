import 'package:wow/app/core/extensions.dart';
import 'package:wow/features/subscription/page/subscription_page.dart';
import 'package:wow/features/transactions/bloc/transactions_bloc.dart';
import 'package:wow/features/transactions/model/transactions_model.dart';
import 'package:wow/features/transactions/page/transactions_page.dart';
import 'package:wow/features/transactions/repo/transactions_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/features/transactions/widgets/transaction_card.dart';
import 'package:wow/features/wallet/widgets/wallet_card.dart';
import 'package:wow/features/wallet/bloc/wallet_bloc.dart';
import 'package:wow/features/wallet/model/wallet_model.dart';
import 'package:wow/features/wallet/repo/wallet_repo.dart';
import 'package:wow/features/wallet/widgets/wallet_transaction_view.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../app/core/dimensions.dart';
import '../../../app/core/images.dart';
import '../../../app/core/styles.dart';
import '../../../app/core/text_styles.dart';
import '../../../app/localization/language_constant.dart';
import '../../../components/animated_widget.dart';
import '../../../components/custom_app_bar.dart';
import '../../../components/custom_loading_text.dart';
import '../../../components/empty_widget.dart';
import '../../../components/shimmer/custom_shimmer.dart';
import '../../../data/config/di.dart';
import '../../../main_models/search_engine.dart';


class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late ScrollController controller;

  @override
  void initState() {
    controller = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, 
      child: Scaffold(
        appBar: CustomAppBar(
          title: getTranslated("wallet"),
        ),
        body: SafeArea(
          child: BlocProvider(
            create: (context) => WalletBloc(repo: sl<WalletRepo>())
              ..customScroll(controller),
              //
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL.w),
               
                const WalletCard(),
                 TabBar(
              dividerColor: Styles.GREY_BORDER,
              indicatorColor: Styles.PRIMARY_COLOR,
              onTap: (value) {
              
              },
              tabs: [
                Tab(text: getTranslated("transactions", context: context)),
                Tab(text: getTranslated("subscription", context: context)),
                                Tab(text: getTranslated("payments", context: context)),

              ],
            ),

            Expanded(
              child: TabBarView(
                    children: [
                     WalletTransactionView(),
                      SubscriptionPage(),
                      TransactionPage(),
                    ],
                  ),
            ),

          
             
              ],
            ),
          
          ),
        ),
      ),
    );
  
  
  }
}
