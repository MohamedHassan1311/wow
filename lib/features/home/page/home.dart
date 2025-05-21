import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/localization/language_constant.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_widgets/main_app_bar.dart';
import '../../fillter/widget/custom_selete.dart';
import '../widgets/home_card.dart';
import '../widgets/main_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  void initState() {
    // sl<HomeAdsBloc>().add(Click());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return Stack(
            children: [
              HomeCard(),
              SafeArea(
                  child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        CustomNavigator.push(Routes.filterPage);
                      },
                      style: IconButton.styleFrom(
                          backgroundColor: Colors.black, shape: CircleBorder()),
                      icon: Icon(
                        Icons.filter_list,
                        color: Colors.white,
                      )),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      CustomNavigator.push(Routes.recommendationPage);
                    },
                    child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                          decoration: BoxDecoration(
                              color: Styles.WHITE_COLOR,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: Styles.PRIMARY_COLOR, width: 2)),
                          child: Text(
                            getTranslated("get_discount", context: context),
                            style: TextStyle(
                                color: Styles.PRIMARY_COLOR,
                                fontWeight: FontWeight.w500,
                                fontSize: 14),
                          ),
                        )),
                  ),
                ],
              ))
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
