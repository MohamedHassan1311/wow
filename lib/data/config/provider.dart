import 'package:wow/data/config/di.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:wow/features/Favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/fillter/bloc/filtter_bloc.dart';
import 'package:wow/features/fillter/repo/fillter_repo.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import '../../app/core/app_event.dart';
import '../../features/auth/logout/bloc/logout_bloc.dart';
import '../../features/home/bloc/home_ads_bloc.dart';
import '../../features/language/bloc/language_bloc.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/setting/bloc/setting_bloc.dart';

abstract class ProviderList {
  static List<BlocProvider> providers = [
    BlocProvider<LanguageBloc>(
        create: (_) => di.sl<LanguageBloc>()..add(Init())),
    BlocProvider<SettingBloc>(create: (_) => di.sl<SettingBloc>()),
    BlocProvider<ProfileBloc>(create: (_) => di.sl<ProfileBloc>()),
    BlocProvider<UserBloc>(create: (_) => di.sl<UserBloc>()),
    BlocProvider<FilterBloc>(create: (_) => di.sl<FilterBloc>()),
    BlocProvider<FavouritBloc>(create: (_) => di.sl<FavouritBloc>()),
    ///Log out
    BlocProvider<LogoutBloc>(create: (_) => di.sl<LogoutBloc>()),
  ];
}
