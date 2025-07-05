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
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/components/shimmer/custom_shimmer.dart';
import 'package:wow/data/config/di.dart';
import 'package:wow/data/internet_connection/internet_connection.dart';
import 'package:wow/features/marige_request/bloc/marige_request_bloc.dart';
import 'package:wow/features/marige_request/widgets/maridge_req_card.dart';
import 'package:wow/features/recommendation/bloc/recommendation_bloc.dart';
import 'package:wow/features/recommendation/repo/recommendation_repo.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_widgets/person_card.dart';
import '../../../app/localization/language_constant.dart';
import '../../guest/guest_mode_view.dart';

class MarigeRequestPage extends StatefulWidget {
  const MarigeRequestPage({super.key});

  @override
  State<MarigeRequestPage> createState() => _MarigeRequestPageState();
}

class _MarigeRequestPageState extends State<MarigeRequestPage> {
  @override
  void initState() {
    if(UserBloc.instance.isLogin)
    context.read<MarigeRequestBloc>().add(Get());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(getTranslated("marige_request", context: context)),
        ),
        body: !UserBloc.instance.isLogin
            ? const GuestModeView(): Padding(
          padding:  EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
          child: BlocBuilder<MarigeRequestBloc, AppState>(
            builder: (context, state) {
              if (state is Done) {
                   return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: context.read<MarigeRequestBloc>().recommendations?.data.length ?? 0, // Sample count
                        itemBuilder: (context, index) {
                          return MaridgeReqCard(
                            user: context.read<MarigeRequestBloc>().recommendations!.data[index]!,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              if (state is Loading) {
                return CustomShimmerContainer(
                  height: 175.h,
                  width: context.width,
                  radius: 24.w,
                );
              }
              if (state is Empty) {
                return EmptyState(                  );
              }
              if (state is Loading) {
                return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two cards per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: 10,
                  itemBuilder: (context, index) {
                    return CustomShimmerContainer(
                      height: 175.h,
                      width: context.width,
                      radius: 24.w,
                    );
                  }
                );
              }
              if (state is Error) {

                return Column(
                  children: [
                    EmptyState(
                      txt: getTranslated("something_went_wrong"),
                    ),
                    CustomButton(
                      onTap: () {
                        context.read<MarigeRequestBloc>().add(Get());
                      },
                      text: getTranslated("retry"),
                    )
                  ],
                );
              }
              else {
                return SizedBox();
              }
            },
          ),
        ));
    ;
  }
}

