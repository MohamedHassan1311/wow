import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:wow/app/core/images.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/core/text_styles.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/block/repo/block_repo.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/main_models/user_model.dart';
import 'package:wow/main_widgets/person_card.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/main_app_bar.dart';

class BlockPage extends StatefulWidget {
  const BlockPage({super.key});

  @override
  State<BlockPage> createState() => _BlockPageState();
}

class _BlockPageState extends State<BlockPage>
    with AutomaticKeepAliveClientMixin<BlockPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(getTranslated("blocked_users", context: context)),
        ),
        body: BlocProvider(
          create: (context) => BlockBloc(repo: sl<BlockRepo>(),internetConnection: sl<InternetConnection>())..add(Get()),
          child: BlocBuilder<BlockBloc, AppState>(
            builder: (context, state) {
            if (state is Done) {
              return GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: sl.get<BlockBloc>().users.length, // Sample count
                itemBuilder: (context, index) {
                  return PersoneCard(
                    user: sl.get<BlockBloc>().users[index],
                  );
                },
              );
            }
            if (state is Loading) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                child: GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two cards per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 4,
                    ),
                    itemCount: 10, // Sample count
                    itemBuilder: (context, index) {
                      return CustomShimmerContainer(
                        height: 175.h,
                        width: context.width,
                        radius: 24.w,
                      );
                    }),
              );
            }
            if (state is Error || state is Empty) {
              return Column(
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
              );
            } else {
              return SafeArea(child: Container());
            }
          },    
        )));
    ;
  }

  @override
  bool get wantKeepAlive => true;
}
