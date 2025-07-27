import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../data/config/di.dart';
import '../../../helpers/deep_links_helper.dart';
import '../../../helpers/permissions.dart';
import '../../../helpers/remote_config_service.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_models/search_engine.dart';
import '../../notifications/bloc/notifications_bloc.dart';
import '../../profile/bloc/profile_bloc.dart';
import '../../setting/bloc/setting_bloc.dart';
import '../repo/splash_repo.dart';

class SplashBloc extends Bloc<AppEvent, AppState> {
  final SplashRepo repo;
  SplashBloc({required this.repo}) : super(Start()) {
    on<Click>(onClick);
  }

  Future<void> onClick(AppEvent event, Emitter<AppState> emit) async {
    sl<SettingBloc>().add(Get());
    AppConfig.loadConfig();
    if (repo.isLogin) {
        UserBloc.instance.add(Click());


      }
     await DeepLinksHalper().initDeepLinks();
     if (repo.isLogin) {
       sl<ProfileBloc>().add(Get());
       sl<NotificationsBloc>().add(Get(arguments: SearchEngine()));

     } else {
       if (!kDebugMode) {
         await repo.guestMode();
       }
     }

     Future.delayed(const Duration(milliseconds: 4200), () async {
      ///Ask Notification Permission
      PermissionHandler.checkNotificationsPermission();




      ///Get Setting

      if (repo.isFirstTime) {
        CustomNavigator.push(Routes.onBoarding, clean: true);
      } else
      if (!repo.isLogin) {
        CustomNavigator.push(Routes.login, clean: true);
      } else {
        CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
      }
      repo.setFirstTime();
    });
  }
}
