import 'package:wow/data/config/mapper.dart';

class SettingModel extends SingleMapper {
  String? logo;
  String? aboutUs;
  String? termsConditions;
  String? chatTerms;
  String? privacyPolicy;
  String? instagram;
  String? facebook;
  String? tiktok;
  String? whatsapp;
  String? email;
  String? phone;
  String? snapchat;
  String? linkedin;
  String? couponCode;
  String? couponAmount;

  SettingModel({
    this.logo,
    this.aboutUs,
    this.termsConditions,
    this.chatTerms,
    this.privacyPolicy,
    this.instagram,
    this.facebook,
    this.tiktok,
    this.whatsapp,
    this.email,
    this.phone,
    this.snapchat,
    this.linkedin,
    this.couponCode,
    this.couponAmount,
  });

  SettingModel.fromJson(Map<String, dynamic> json) {
    logo = json['logo'];
    aboutUs = json['about_us'];
    chatTerms = json['chat_terms'];
    termsConditions = json['terms_conditions'];
    privacyPolicy = json['privacy'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    tiktok = json['tiktok'];
    whatsapp = json['whatsapp'];
    email = json['email'];
    phone = json['phone'];
    snapchat = json['snap_chat'];
    linkedin = json['linkedin'];
    couponCode = json['coupon_code'];
    couponAmount = json['coupon_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['logo'] = logo;
    data['about_us'] = aboutUs;
    data['terms_conditions'] = termsConditions;
    data['privacyPolicy'] = privacyPolicy;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['tiktok'] = tiktok;
    data['whatsapp'] = whatsapp;
    data['email'] = email;
    data['phone'] = phone;
    data['snap_chat'] = snapchat;
    data['linkedin'] = linkedin;
    data['coupon_code'] = couponCode;
    data['coupon_amount'] = couponAmount;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return SettingModel.fromJson(json['data'] ?? {});
  }
}
