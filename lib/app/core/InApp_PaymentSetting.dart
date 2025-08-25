  import 'dart:io';

class InAppPaymentSetting {
  static const String shopperResultUrl= "com.softwarecloudapp.wow.payment";
  static const String merchantId= "merchant.com.softwarecloudapp.wow.payment";
  static const String countryCode="SA";
  static getLang() {
    if (Platform.isIOS) {
      return  "en"; // ar
    } else {
      return "en_US"; // ar_AR
    }
  }
}
