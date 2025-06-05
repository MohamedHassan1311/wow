import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:wow/features/chats/bloc/chats_bloc.dart';
import 'package:wow/features/favourit/bloc/favourit_bloc.dart';
import 'package:wow/features/favourit/repo/favourit_repo.dart';
import 'package:wow/features/addresses/repo/addresses_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wow/features/auth/register/repo/register_repo.dart';
import 'package:wow/features/block/bloc/block_bloc.dart';
import 'package:wow/features/block/repo/block_repo.dart';
import 'package:wow/features/fillter/bloc/filtter_bloc.dart';
import 'package:wow/features/fillter/repo/fillter_repo.dart';
import 'package:wow/features/interest/bloc/interest_bloc.dart';
import 'package:wow/features/interest/repo/interest_repo.dart';
import 'package:wow/features/marige_request/bloc/marige_request_bloc.dart';
import 'package:wow/features/marige_request/repo/marige_request_repo.dart';
import 'package:wow/features/marriage_conditions/repo/marriage_conditions_repo.dart';
import 'package:wow/features/plans/repo/plan_repo.dart';
import 'package:wow/features/recommendation/repo/recommendation_repo.dart';
import 'package:wow/features/report/repo/report_repo.dart';
import 'package:wow/features/subscription/bloc/subscription_bloc.dart';
import 'package:wow/features/subscription/repo/subscription_repo.dart';
import 'package:wow/features/wallet/repo/wallet_repo.dart';
import '../../app/theme/theme_provider/theme_provider.dart';
import '../../features/add_address/repo/add_address_repo.dart';
import '../../features/auth/activation_account/repo/activation_account_repo.dart';
import '../../features/auth/deactivate_account/repo/deactivate_account_repo.dart';
import '../../features/auth/forget_password/repo/forget_password_repo.dart';
import '../../features/auth/login/repo/login_repo.dart';
import '../../features/auth/logout/bloc/logout_bloc.dart';
import '../../features/auth/logout/repo/logout_repo.dart';
import '../../features/auth/reset_password/repo/reset_password_repo.dart';
import '../../features/auth/social_media_login/repo/social_media_repo.dart';
import '../../features/auth/verification/repo/verification_repo.dart';
import '../../features/profile_details/repo/profile_details_repo.dart';
import '../../features/chat/repo/chat_repo.dart';
import '../../features/chats/repo/chats_repo.dart';
import '../../features/change_password/repo/change_password_repo.dart';
import '../../features/complete_profile/repo/complete_profile_repo.dart'
    show CompleteProfileRepo;
import '../../features/edit_profile/repo/edit_profile_repo.dart';
import '../../features/faqs/repo/faqs_repo.dart';
import '../../features/countries/repo/countries_repo.dart';
import '../../features/home/bloc/home_user_bloc.dart';
import '../../features/home/repo/home_repo.dart';
import '../../features/language/bloc/language_bloc.dart';
import '../../features/language/repo/language_repo.dart';
import '../../features/maps/repo/maps_repo.dart';
import '../../features/notifications/repo/notifications_repo.dart';
import '../../features/personal_info/repo/perosnal_info_repo.dart';
import '../../features/profile/bloc/profile_bloc.dart';
import '../../features/profile/repo/profile_repo.dart';
import '../../features/setting/bloc/setting_bloc.dart';
import '../../features/setting/repo/setting_repo.dart';
import '../../features/contact_with_us/repo/contact_with_us_repo.dart';
import '../../features/setting_option/repo/setting_option_repo.dart';
import '../../features/transactions/repo/transactions_repo.dart';
import '../../helpers/pickers/repo/picker_helper_repo.dart';
import '../../helpers/social_media_login_helper.dart';
import '../../main_blocs/user_bloc.dart';
import '../../main_page/bloc/dashboard_bloc.dart';
import '../../main_page/repo/dashboard_repo.dart';
import '../../main_repos/download_repo.dart';
import '../../main_repos/user_repo.dart';
import '../api/end_points.dart';
import '../internet_connection/internet_connection.dart';
import '../local_data/local_database.dart';
import '../dio/dio_client.dart';
import '../dio/logging_interceptor.dart';
import '../../features/splash/repo/splash_repo.dart';
import '../securty/secure_storage.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => LocaleDatabase());
  sl.registerLazySingleton(() => DioClient(
        EndPoints.baseUrl,
        dio: sl(),
        loggingInterceptor: sl(),
        sharedPreferences: sl(),
      ));
  sl.registerLazySingleton(() => SocialMediaLoginHelper());
  sl.registerLazySingleton(() => InternetConnection(connectivity: sl()));

  /// Repository
  sl.registerLazySingleton(
      () => LocalizationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => SettingRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => DashboardRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => FillterRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => FaqsRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => FavouritRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => InterestRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => MarigeRequestRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => BlockRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => PlanRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ReportRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => MarriageConditionsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => DownloadRepo());

  sl.registerLazySingleton(
      () => CountriesRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => PickerHelperRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => SplashRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => UserRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => LoginRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => RecommendationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => RegisterRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => CompleteProfileRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => PersonalInfoRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => SettingOptionRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => VerificationRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ForgetPasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ResetPasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChangePasswordRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => LogoutRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ActivationAccountRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ProfileRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => EditProfileRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => MapsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => SocialMediaRepo(
      sharedPreferences: sl(), dioClient: sl(), socialMediaLoginHelper: sl()));

  sl.registerLazySingleton(
      () => DeactivateAccountRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => WalletRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(
      () => ProfileDetailsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => NotificationsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => HomeRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => AddressesRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => AddAddressRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChatsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ChatRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => ContactWithUsRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(
      () => TransactionsRepo(sharedPreferences: sl(), dioClient: sl()));

  //provider
  sl.registerLazySingleton(() => LanguageBloc(repo: sl()));
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => SettingBloc(repo: sl()));
  sl.registerLazySingleton(() => DashboardBloc(repo: sl()));
  sl.registerLazySingleton(() => ProfileBloc(repo: sl()));
  sl.registerLazySingleton(() => UserBloc(repo: sl()));

  sl.registerLazySingleton(() => FilterBloc(repo: sl()));
  sl.registerLazySingleton(
      () => HomeUserBloc(repo: sl(), internetConnection: sl()));

  sl.registerLazySingleton(
      () => FavouritBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(
      () => InterestBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(
      () => MarigeRequestBloc(repo: sl(), internetConnection: sl()));
  sl.registerLazySingleton(
      () => SubscriptionRepo(sharedPreferences: sl(), dioClient: sl()));

  sl.registerLazySingleton(() => ChatsBloc(repo: sl()));

  ///Log out
  sl.registerLazySingleton(() => LogoutBloc(repo: sl()));

  sl.registerLazySingleton(
      () => BlockBloc(repo: sl(), internetConnection: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => SecureStorage(flutterSecureStorage: sl()));
  sl.registerLazySingleton(() => LoggingInterceptor());
}
