import 'dart:io';
import 'package:wow/features/chats/model/chats_model.dart';
import 'package:wow/features/favourit/page/favourit_page.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';
import 'package:wow/features/addresses/page/addresses_page.dart';
import 'package:wow/features/block/page/add_to_block_page.dart';
import 'package:wow/features/block/page/block_page.dart';
import 'package:wow/features/interest/page/interest_page.dart';
import 'package:wow/features/marriage_conditions/page/marriage_conditions_page.dart';
import 'package:wow/features/plans/page/plans_page.dart';
import 'package:wow/features/profile_details/page/profile_details_page.dart';
import 'package:wow/features/chats/page/chats.dart';
import 'package:wow/features/edit_profile/page/edit_profile_page.dart';
import 'package:wow/features/fillter/page/fillter_result.dart';
import 'package:wow/features/fillter/page/filtter_page.dart';
import 'package:wow/features/maps/models/location_model.dart';
import 'package:wow/features/payment/in_app_web_view_page.dart';
import 'package:wow/features/recommendation/page/recommendation.dart';
import 'package:wow/features/report/page/add_to_report_page.dart';
import 'package:wow/features/setting/pages/settings.dart';
import 'package:wow/features/subscription/page/subscription_page.dart';
import 'package:wow/features/transactions/page/transactions_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wow/features/wallet/page/wallet_page.dart';
import 'package:wow/main_models/user_model.dart';
import '../features/add_address/page/add_address_page.dart';
import '../features/all_users/page/all_users_page.dart';
import '../features/chat/page/chat_page.dart';
import '../components/video_preview_page.dart';
import '../features/chats/page/end_chat_page.dart';
import '../features/complete_profile/page/CompleteProfile.dart';
import '../features/contact_with_us/page/contact_with_us_page.dart';
import '../features/faqs/page/faqs_page.dart';
import '../features/maps/page/pick_map_page.dart';
import '../features/notifications/page/notifications_page.dart';
import '../features/payment/payment_view.dart';
import '../features/personal_info/page/PersonalInfo.dart';
import '../features/personal_info/repo/perosnal_info_repo.dart';
import '../features/setting/pages/chat_terms.dart';
import '../main.dart';
import 'routes.dart';
import '../main_page/page/dashboard.dart';
import '../features/profile/page/my_profile.dart';
import '../features/auth/forget_password/page/forget_password.dart';
import '../features/auth/login/page/login.dart';
import '../features/auth/register/page/register.dart';
import '../features/auth/reset_password/page/reset_password.dart';
import '../features/auth/verification/model/verification_model.dart';
import '../features/auth/verification/page/verification.dart';
import '../features/change_password/page/change_password_page.dart';
import '../features/on_boarding/pages/on_boarding.dart';
import '../features/setting/pages/privacy_policy.dart';
import '../features/setting/pages/terms.dart';
import '../features/splash/page/splash.dart';

abstract class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldState =
      GlobalKey<ScaffoldMessengerState>();

  static Route<dynamic> onCreateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.app:
        return _pageRoute(const MyApp(), Routes.app);
      case Routes.splash:
        return _pageRoute(const Splash(), Routes.splash);
      case Routes.onBoarding:
        return _pageRoute(const OnBoarding(), Routes.onBoarding);
      case Routes.login:
        return _pageRoute(Login(), Routes.login);
      case Routes.register:
        return _pageRoute(Register(userName: settings.arguments as String?), Routes.register);
      case Routes.CompleteProfile:
        return _pageRoute(
          CompleteProfile(
            isEdit: settings.arguments != null ? settings.arguments as bool : false,
          ),
          Routes.CompleteProfile,
        );
      case Routes.personalInfo:
        return _pageRoute(
          PersonalInfo(
            isEdit: settings.arguments != null ? settings.arguments as bool : false,
          ),
          Routes.personalInfo,
        );
      case Routes.filterPage:
        return _pageRoute(
          FilterPage(
            isEdit: settings.arguments != null ? settings.arguments as bool : false,
          ),
          Routes.filterPage,
        );
      case Routes.filterResult:
        return _pageRoute(FilterResult(), Routes.filterResult);
      case Routes.forgetPassword:
        return _pageRoute(const ForgetPassword(), Routes.forgetPassword);
      case Routes.favouritPage:
        return _pageRoute(FavouritPage(), Routes.favouritPage);
      case Routes.resetPassword:
        return _pageRoute(
          ResetPassword(data: settings.arguments as VerificationModel),
          Routes.resetPassword,
        );
      case Routes.plans:
        return _pageRoute(PlansPage(), Routes.plans);
      case Routes.changePassword:
        return _pageRoute(const ChangePassword(), Routes.changePassword);
      case Routes.marriageConditions:
        return _pageRoute(const MarriageConditionsPage(), Routes.marriageConditions);
      case Routes.verification:
        return _pageRoute(
          Verification(model: settings.arguments as VerificationModel),
          Routes.verification,
        );
      case Routes.editProfile:
        return _pageRoute(
          EditProfilePage(fromComplete: (settings.arguments as bool?) ?? false),
          Routes.editProfile,
        );
      case Routes.profile:
        return _pageRoute(const MyProfile(), Routes.profile);
      case Routes.dashboard:
        return _pageRoute(
          DashBoard(index: settings.arguments as int?),
          Routes.dashboard,
        );
      case Routes.interestPage:
        return _pageRoute(InterestPage(), Routes.interestPage);
      case Routes.blockPage:
        return _pageRoute(BlockPage(), Routes.blockPage);
      case Routes.AddToBlockPage:
        final Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        return _pageRoute(
          AddToBlockPage(
            user: map["user"] as UserModel,
            chatId: map['chatId'] as int?,
            isFromChat: map["isFromChat"] as bool,
          ),
          Routes.AddToBlockPage,
        );
      case Routes.addresses:
        return _pageRoute(const AddressesPage(), Routes.addresses);
      case Routes.addToReportPage:
        final Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
        return _pageRoute(
          AddToReportPage(
            user: map["user"] as UserModel,
            isFromChat: map["isFromChat"] as bool,
          ),
          Routes.addToReportPage,
        );
      case Routes.addAddress:
        return _pageRoute(
          AddAddressPage(address: settings.arguments as AddressModel?),
          Routes.addAddress,
        );
      case Routes.endChatPage:
        return _pageRoute(
          EndChatPage(chatModel: settings.arguments as ChatModel),
          Routes.endChatPage,
        );
      case Routes.chats:
        return _pageRoute(const Chats(), Routes.chats);
      case Routes.chat:
        return _pageRoute(ChatPage(data: settings.arguments as ChatModel), Routes.chat);
      case Routes.notifications:
        return _pageRoute(const NotificationsPage(), Routes.notifications);
      case Routes.profileDetails:
        return _pageRoute(
          ProfileDetailsPage(profileDetailsId: settings.arguments as int?),
          Routes.profileDetails,
        );
      case Routes.settings:
        return _pageRoute(const Settings(), Routes.settings);
      case Routes.wallet:
        return _pageRoute(const WalletPage(), Routes.wallet);
      case Routes.subscriptions:
        return _pageRoute(SubscriptionPage(), Routes.subscriptions);
      case Routes.recommendationPage:
        return _pageRoute(RecommendationPage(), Routes.recommendationPage);

        case Routes.allUsers:
        return _pageRoute(AllUsersPage(), Routes.recommendationPage);
      case Routes.videoPreview:
        return _pageRoute(
          VideoPreviewPage(data: settings.arguments as Map),
          Routes.videoPreview,
        );
      case Routes.pickLocation:
        return _pageRoute(
          PickMapPage(data: settings.arguments as LocationModel),
          Routes.pickLocation,
        );
      case Routes.payment:
        return _pageRoute(
          PaymentPage(url: settings.arguments as String),
          Routes.payment,
        );
      case Routes.transactions:
        return _pageRoute(const TransactionPage(), Routes.transactions);
      case Routes.contactWithUs:
        return _pageRoute(const ContactWithUsPage(), Routes.contactWithUs);
      case Routes.privacy:
        return _pageRoute(const PrivacyPolicy(), Routes.privacy);
      case Routes.terms:
        return _pageRoute(const Terms(), Routes.terms);
      case Routes.chatTerms:
        return _pageRoute(const ChatTerms(), Routes.chatTerms);
      case Routes.faqs:
        return _pageRoute(const FaqsPage(), Routes.faqs);
      default:
        return MaterialPageRoute(builder: (_) => const MyApp());
    }
  }

  static _pageRoute(Widget child,route) => Platform.isIOS
      ? CupertinoPageRoute(
      settings: route != null ? RouteSettings(name: route) : null,

      builder: (_) => child)
      : MaterialPageRoute(
      settings: route != null ? RouteSettings(name: route) : null,

      builder: (_) => child);



  static pop({dynamic result}) {
    if (navigatorState.currentState!.canPop()) {
      navigatorState.currentState!.pop(result);
    }
  }

  static push(String routeName,
      {arguments, bool replace = false, bool clean = false}) {
    if (clean) {
      return navigatorState.currentState!.pushNamedAndRemoveUntil(
        routeName,
            (route) => route.settings.name == Routes.dashboard,
        arguments: arguments,
      );
    } else if (replace) {
      return navigatorState.currentState!.pushReplacementNamed(
        routeName,
        arguments: arguments,
      );
    } else {
      return navigatorState.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
  }
}
