import 'package:wow/app/core/app_state.dart';
import 'package:wow/app/core/styles.dart';

import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import '../../../app/core/svg_images.dart';
import '../../../app/localization/language_constant.dart';

import '../../../components/empty_widget.dart';
import '../../../main_blocs/user_bloc.dart';

import '../../guest/guest_mode_view.dart';
import '../../notifications/widgets/notificaton_button.dart';
import '../widgets/home_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<UserBloc, AppState>(
        builder: (context, state) {
          return !UserBloc.instance.isLogin
              ? const GuestModeView()
              : context.read<UserBloc>().user?.proposal_suspend == 1
                  ? EmptyState(
                      img: SvgImages.ring,
                      isSvg: true,
                      txtColor: Styles.PRIMARY_COLOR,
                      txt: getTranslated("mardig_massge"),
                    )
                  : Stack(
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
                                    backgroundColor: Colors.black,
                                    shape: CircleBorder()),
                                icon: Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                )),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                CustomNavigator.push(Routes.allUsers);
                              },
                              child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Styles.WHITE_COLOR,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: Text(
                                      getTranslated("all_users",
                                          context: context),
                                      style: TextStyle(
                                          color: Styles.PRIMARY_COLOR,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  )),
                            ),
                            NotificationButton()
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
