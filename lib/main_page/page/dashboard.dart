import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/features/chats/page/chats_page.dart';
import 'package:wow/features/home/bloc/home_user_bloc.dart';
import 'package:wow/features/home/page/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wow/features/more/page/more.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/routes.dart' show Routes;
import '../../data/config/di.dart';
import '../../data/internet_connection/internet_connection.dart';
import '../../features/Favourit/page/favourit_page.dart';
import '../../helpers/check_on_the_version.dart';
import '../../navigation/custom_navigation.dart';
import '../bloc/dashboard_bloc.dart';
import '../widget/nav_bar.dart';

class DashBoard extends StatefulWidget {
  final int? index;

  const DashBoard({this.index, super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  late final StreamSubscription<List<ConnectivityResult>>
      connectivitySubscription;
  late final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  void initState() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    if (widget.index != null) {
      DashboardBloc.instance.updateSelectIndex(widget.index!);


    }

    ///App Link
    initDeepLinks();

    ///Init Data
    initData();

    connectivitySubscription =
        sl<InternetConnection>().connectionStream(initData);
    // CheckOnTheVersion.checkOnVersion();
    super.initState();
  }

  initData() {
          sl<HomeUserBloc>().add(Click());

    // if (sl<UserBloc>().isLogin) {
    //   sl<UserBloc>().add(Click());
    //    if(UserBloc.instance.user?.nickname==null){
    //     CustomNavigator.push(Routes.CompleteProfile, );
    //   }
    //   // sl<ProfileBloc>().add(Get());
    // }
  }

  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        log('onAppLink: $uri');
        openAppLink(uri);
      },
    );
  }

  void openAppLink(Uri uri) {
    log("routeName: ${uri.path.replaceAll("/", "")}");
    log("queryParameters: ${uri.queryParameters["id"]}");
    CustomNavigator.push(
      uri.path.replaceAll("/", ""),
      arguments: int.parse(uri.queryParameters["id"] ?? "0"),
    );
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Widget fragment(int index) {
    switch (index) {
      case 0:
        return const Home();
      case 1:
        // return const SizedBox();
        return const FavouritPage();
      case 2:
        return const SizedBox();
        case 3:
          // return const SizedBox();
        return const ChatsPage();
        case 4:
        return const More();
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: DashboardBloc.instance.selectIndexStream,
        builder: (context, snapshot) {
          return BlocBuilder<UserBloc, AppState>(
            builder: (context, state) {
              return Scaffold(
                key: scaffoldKey,
                bottomNavigationBar: const NavBar(),
                body: fragment(snapshot.hasData ? snapshot.data! : 0),
              );
            },
          );
        });
  }
}
