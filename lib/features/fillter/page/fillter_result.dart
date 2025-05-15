import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/custom_app_bar.dart' show CustomAppBar;
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
      body:  BlocBuilder<FilterBloc, AppState>(
      builder: (context, state) {
          if (state is Done) {
            return GridView.builder(
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
              return PersoneCard(user: context.read<FilterBloc>().users[index]);
            },
          );
        }
        if (state is Loading) {
          return Center(child: CircularProgressIndicator(),);
        }
        return SizedBox();
      }),
    );
  }
}
