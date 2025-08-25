import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';
import 'package:wow/app/core/app_event.dart';
import 'package:wow/app/core/app_state.dart';
import 'package:wow/features/chats/page/chats.dart';
import 'package:wow/features/home/bloc/home_user_bloc.dart';
import 'package:wow/features/home/page/home.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:wow/features/interest/page/interest_page.dart';
import 'package:wow/features/marige_request/page/marige_request_page.dart';
import 'package:wow/features/more/page/more.dart';
import 'package:wow/features/profile/bloc/profile_bloc.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/routes.dart' show Routes;
import '../../app/core/dimensions.dart';
import '../../app/core/svg_images.dart';
import '../../app/localization/language_constant.dart';
import '../../components/custom_alert_dialog.dart';
import '../../data/config/di.dart';
import '../../data/internet_connection/internet_connection.dart';
import '../../features/complete_profile/widget/submit_success_dialog.dart';
import '../../features/favourit/page/favourit_page.dart';
import '../../features/setting/bloc/setting_bloc.dart';
import '../../helpers/check_on_the_version.dart';
import '../../helpers/remote_config_service.dart';
import '../../main_widgets/custom_request_dialog.dart';
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

    if (sl<ProfileBloc>().isLogin) {
      initData();
      sl<ProfileBloc>().add(Get());
    }

    // CheckOnTheVersion.checkOnVersion();
    super.initState();
  }

  initData() {
    if (UserBloc.instance.isLogin &&
        UserBloc.instance.user?.isVerified == 0 &&UserBloc.instance.user?.status == 1 &&
        UserBloc.instance.user?.nationalityId?.code?.toLowerCase() == "sa") {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        CustomAlertDialog.show(
            dailog: AlertDialog(
                contentPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                insetPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE.w,
                    horizontal: 20),
                shape: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0)),
                content: SubmitSuccessDialog(
                  fromVerify: true,
                  isWrongData:
                      UserBloc.instance.user?.thereIsValidation == true,
                )));
      });
    } else {
      if (          !AppConfig.isIosFlag&&
        UserBloc.instance.user?.nationalityId?.code?.toLowerCase() == "sa"&&widget.index==0&&  context.read<SettingBloc>().model?.couponCode!=null&&context.read<SettingBloc>().model?.couponCode!="" ) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CustomAlertDialog.show(dailog:
              BlocBuilder<SettingBloc, AppState>(builder: (context, state) {
            return AlertDialog(
                contentPadding: EdgeInsets.symmetric(
                    vertical: Dimensions.PADDING_SIZE_DEFAULT.w,
                    horizontal: Dimensions.PADDING_SIZE_DEFAULT.w),
                shape: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(20.0)),
                content: CustomDialog(
                  name: getTranslated("welcome"),
                  showBackButton: false,
                  confirmButtonText: getTranslated("ok"),
                  showSympole: false,
                  discription: getTranslated("DiscountMessage")
                      .replaceAll("##",
                          context.read<SettingBloc>().model?.couponCode ?? "")
                      .replaceAll(
                          "*",
                          context.read<SettingBloc>().model?.couponAmount ??
                              ""),
                  image: SvgImages.coupons,
                ));
          }));
        });
      }
      sl<HomeUserBloc>().add(Click());
    }

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
        return const InterestPage();
      case 2:
        return const MarigeRequestPage();
      case 3:
        // return const SizedBox();
        return const Chats();
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
