import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String domain = dotenv.env['DOMAIN_DEV'] ?? "";
  static String baseUrl = dotenv.env['BASE_URL_DEV'] ?? "";
  static String apiKey = dotenv.env['API_KEY'] ?? "";
  static chatPort(id) => '${dotenv.env['CHAT_PORT']}$id';
  static String googleMapsBaseUrl = dotenv.env['GOOGLE_MAPS_BASE_URL'] ?? "";
  static const String generalTopic = 'wow';
  static specificTopic(id) => '$id';

  ///Auth
  static const String socialMediaAuth = 'google/login';
  static const String forgetPassword = 'reset-password-email';
  static const String resetPassword = 'new-password';
  static  String changePassword(id) => 'change-password/$id';
  static const String register = 'register';
  static const String logIn = 'login';
  static const String resend = 'resend-otp';
  static const String verifyOtp = 'check-verification-code';
  static const String verifyOtpResetPass = 'reset-password-check-code';
  static String suspendAccount(userid) => 'client/destroy/$userid';
  static String freezeAccount(userid) => 'client/suspend/$userid';
  static  String reactivateAccount (userid) => 'client/suspend/$userid';

  ///User Profile
  static String editProfile(id) => 'client/$id';
  static String storeProfile(id) => 'store/client/$id';
  static String profile(id) => 'client/$id';
  static const String bankInfo = 'bank_info';
  static const String submitFilter = '/client/filters';

  static String guardianRequest(id) => 'client/guardian/request/$id';


  ///Home
  static String homeUser(id) => 'client/random/$id';

  ///Wallet
  static String wallets(id) => 'transactions/wallet/$id';

// subscriptions
  static String subscriptions(id) => 'subscriptions/$id';
  static String subscribe(id) => 'subscriptions/store/$id';
  static const String cancelSubscription = 'subscriptions/cancel';
  static const String checkSubscriptionStatus = 'subscriptions/check';

  ///Favourit
  ///
  static String getFavouritSent(id) => '/favorites/sent/$id';
  static String getFavouritReceived(id) => '/favorites/received/$id';

  static const String addToFavourit = '/send/favorite';
  static const String deleteFavourit = '/remove/favorite';

  ///Interest
  static String getInterest(id) => '/interests/received/$id';
  static String getInterestSent(id) => '/interests/sent/$id';
  static const String addToInterest = '/send/interest';
  static const String removeInterest = '/remove/interest';

  ///Plans
  static const String getPlans = '/plan';
  static String getPlanDetails(id) => '/plans/$id';

  /// Recommendation
  static String getRecommendation(id) => '/client/recomendations/$id';

  ///Block
  static const String block = '/blocked/block';
  static const String unblock = '/blocked/unblock';
  static String getBlockedUsers(id) => '/blocked/by/$id';

  ///Report
  static const String report = '/reported/report';
  static String getReportedUsers(id) => '/report/users/$id';

  ///Marige Request
  static String getmarigeRequestSend(id) => '/proposals/send/$id';
  static String getmarigeRequestReceived(id) => '/proposals/received/$id';
  static String sendMarigeRequest = '/proposals';
  static String acceptMarigeRequest(id) => '/proposals/accept/$id';
  static String rejectMarigeRequest(id) => '/proposals/reject/$id';
  static String cancelMarigeRequest(id) => '/proposals/cancel/$id';

  ///Marriage Conditions
  static const String marriageConditions = '/marriage-conditions';

  ///Marketplace
  static const String marketplace = 'marketplace';

  ///Categories && Products
  static const String vendors = 'vendors';
  static String vendorDetails(id) => 'vendors/$id';
  static const String brands = 'brands';
  static const String categories = 'categories';
  static const String products = 'products';
  static const String bestSellers = 'best_sellers';
  static productDetails(id) => 'product/$id';

  ///cities
  static const String cities = 'cities';

  ///Talents
  static const String talents = 'talents';

  ///Wishlist
  static const String wishlist = 'wishlist';
  static updateWishlist(id) => 'updateWishlist/$id';

  ///Feedbacks
  static feedbacks(id) => 'users/$id/feedbacks';
  static const String sendFeedback = 'feedbacks';

  ///Addresses
  static const String addresses = 'addresses';
  static const String addAddress = 'add-address';
  static deleteAddress(id) => 'address/$id';
  static editAddress(id) => 'address/$id';
  static addressDetails(id) => 'address/$id';

  ///Chats
  static const String createChat = 'chats';
  static const String sendNotificationConversation = 'conversation/send';
  static chatSMessages(id) => 'conversation/index/$id';
  static deleteChat(id) => 'chats/$id';
  static updateChat(id) => 'conversation/update/$id';
  static chatDetails(id) => 'chats/$id';
  static chatMessages(id) => 'chat-messages/$id';
  static const String uploadFile = 'conversation/uploadPhoto';
  static startNewChat(id) => 'conversation/save/$id';

  ///Notification
  static String notifications(id) => 'notification/$id';
  static readNotification({ userId,id}) => 'notification/read/$userId/$id';
  static deleteNotification(id) => 'notification/delete/$id';

  ///Create Request
  static const String createRequest = 'company/orders';
  static const String createCustomRequest = 'company/custom_requests';

  ///Requests&Details
  static const String companyRequests = 'company/orders';
  static const String talentRequests = 'talent/orders';
  static companyRequest(id) => 'company/orders/$id';
  static companyStaff(id) => 'company/orders/$id/talents';
  static talentRequest(id) => 'talent/orders/$id';

  ///Request Actions
  static acceptRequest(id) => 'talent/orders/$id/accept';
  static rejectRequest(id) => 'talent/orders/$id/reject';
  static confirmAttended(id) => 'talent/orders/$id/confirm-attend';
  static confirmStaffAttendance(id) => 'company/orders/$id/is-attend';
  static cancelRequest(userType, id) => '$userType/orders/$id/cancel';
  static requestStatus(type) => '$type/get-filter';
  static const String cancelReasons = 'cancel-reasons';

  ///Check Out
  static checkOutOrder(id) => 'company/orders/$id/check-out';
  static checkOutByBankTransfer(id) => 'company/orders/$id/pay-by-bank';
  static applyOrderCoupon(id) => 'company/orders/$id/check-coupon';
  static checkPayment(id) => 'payment/status/$id';

  ///Transactions
  static String transactions(id) => 'transactions/$id';

  ///Cart
  static const String cart = 'cart';
  static const String addToCart = 'cart/add';
  static const String updateCart = 'update/cart/quantity';
  static const String removeFromCart = 'cart/remove';
  static const checkOutProduct = 'check-out';
  static const applyProductCoupon = 'check-coupon';

  ///Setting
  static const String settings = 'setting';
  static const String optionsSettings = 'options/setting';
  static const String faqs = 'faqs';
  static const String whoUs = 'who-us';
  static const String contactUs = 'contact-us';
  static const String countries = 'countries';

  ///Share
  static shareRoute(route, id) => "$baseUrl$route/?id=$id";

  ///Upload File Service
  static const String uploadFileService = 'store_attachment';

  /// maps
  static const String geoCodeUrl = '/maps/api/geocode/';
  static const String autoComplete = '/maps/api/place/autocomplete/';
//https://maps.googleapis.com/maps/api/geocode/json?latlng=40.714224,-73.961452&key=AIzaSyB_l2x6zgnLTF4MKxX3S4Df9urLN6vLNP0
//'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=n,&key=AIzaSyB_l2x6zgnLTF4MKxX3S4Df9urLN6vLNP0
}
