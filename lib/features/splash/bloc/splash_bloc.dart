import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wow/navigation/custom_navigation.dart';
import 'package:wow/navigation/routes.dart';
import 'package:geolocator/geolocator.dart';
import '../../../app/core/app_event.dart';
import '../../../app/core/app_state.dart';
import '../../../components/custom_simple_dialog.dart';
import '../../../data/config/di.dart';
import '../../../data/internet_connection/check_connection_dialog.dart';
import '../../../helpers/deep_links_helper.dart';
import '../../../helpers/permissions.dart';
import '../../../helpers/remote_config_service.dart';
import '../../../main_blocs/user_bloc.dart';
import '../../../main_models/search_engine.dart';
import '../../auth/widget/chooes_country_dialog.dart';
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

     await DeepLinksHalper().initDeepLinks();
     if (repo.isLogin) {
       sl<ProfileBloc>().add(Get());
       UserBloc.instance.add(Click());

       sl<NotificationsBloc>().add(Get(arguments: SearchEngine()));

     } else {
       if (!kDebugMode) {
         await repo.guestMode();
       }
     }

     Future.delayed(const Duration(milliseconds: 4200), () async {
      ///Ask Notification Permission
      // PermissionHandler.checkNotificationsPermission();




      ///Get Setting

      if (repo.isFirstTime) {
        await  CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            coverAllPage: true,
            customWidget: ChooesCountryDialog(onCountrySelected: (String selectedCountry) {
              sl<SettingBloc>().   updateNationality(selectedCountry);
              CustomNavigator.pop();
            },));
        CustomNavigator.push(Routes.onBoarding, clean: true);
        repo.setFirstTime();
        return;
      } else
      if (!repo.isLogin) {
        await  CustomSimpleDialog.parentSimpleDialog(
            canDismiss: false,
            coverAllPage: true,
            customWidget: ChooesCountryDialog(onCountrySelected: (String selectedCountry) {
              sl<SettingBloc>().   updateNationality(selectedCountry);
              CustomNavigator.pop();
            },));
        CustomNavigator.push(Routes.login, clean: true);

        return;

      } else {
        CustomNavigator.push(Routes.dashboard, clean: true, arguments: 0);
        return;

      }

    });
  }
}
