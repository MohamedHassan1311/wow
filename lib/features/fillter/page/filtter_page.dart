import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/app/core/styles.dart';
import 'package:wow/app/localization/language_constant.dart';
import 'package:wow/components/animated_widget.dart';
import 'package:wow/components/custom_button.dart';
import 'package:wow/components/custom_expansion_tile.dart';
import 'package:wow/features/fillter/widget/age.dart';
import 'package:wow/features/fillter/widget/city_and_culture.dart';
import 'package:wow/features/fillter/widget/fashion_style.dart';
import 'package:wow/features/fillter/widget/health_and_lifestyle.dart';
import 'package:wow/main_models/search_engine.dart';

import '../../../../data/config/di.dart';
import '../bloc/filtter_bloc.dart';
import '../repo/fillter_repo.dart';
import '../widget/Social_status_and _class.dart';

class FilterPage extends StatefulWidget {
  final bool isEdit;
  const FilterPage({super.key, this.isEdit = false});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated("filter")),
      ),
      body: SafeArea(
        child: BlocBuilder<FilterBloc, AppState>(
          builder: (context, state) {
            return ListAnimator(
              data: [
                SocialStatusAndClassleGuardianData(),
                Divider(
                  color: Styles.SMOKED_WHITE_COLOR,
                ),
                Age(),
                Divider(
                  color: Styles.SMOKED_WHITE_COLOR,
                ),
                FashionStyle(),
                Divider(
                  color: Styles.SMOKED_WHITE_COLOR,
                ),
                HealthAndLifestyle(),
                Divider(
                  color: Styles.SMOKED_WHITE_COLOR,
                ),
                CustomExpansionTile(
                    backgroundColor: Styles.WHITE_COLOR,
                    initiallyExpanded: false,
                    title: getTranslated("city_and_culture"),
                    children: [
                      CityAndCulture(),
                    ]),
                Divider(
                  color: Styles.SMOKED_WHITE_COLOR,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: CustomButton(
                      isLoading: state is Loading,
                      text: getTranslated("save"),
                      onTap: () {
                        context.read<FilterBloc>().add(Click(arguments: SearchEngine()));
                      },
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
