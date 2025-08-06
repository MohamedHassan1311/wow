import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/dimensions.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_app_bar.dart' show CustomAppBar;
import 'package:wow/components/custom_loading_text.dart';
import 'package:wow/components/empty_widget.dart';
import 'package:wow/features/fillter/bloc/filtter_bloc.dart';
import 'package:wow/main_widgets/person_card.dart';

class FilterResult extends StatelessWidget {
  const FilterResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: getTranslated("filter_result", context: context),
      ),
      body: BlocBuilder<FilterBloc, AppState>(builder: (context, state) {
        if (state is Done) {
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: context.read<FilterBloc>().controller,
                  itemCount: context.read<FilterBloc>().users.length,
                  padding: EdgeInsets.all(8.0), // padding around the grid

                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 4,
                    // number of items in each row
                    mainAxisSpacing: 4.0, // spacing between rows
                    crossAxisSpacing: 8.0, // spacing between columns
                  ),

                  itemBuilder: (context, index) {
                    return PersoneCard(
                        user: context.read<FilterBloc>().users[index]);
                  },
                ),
              ),
              CustomLoadingText(loading: state.loading),
            ],
          );
        }
        if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
          return Center(
            child: Text(getTranslated("no_data", context: context)),
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
        }
        return SizedBox();
      }),
    );
  }
}
