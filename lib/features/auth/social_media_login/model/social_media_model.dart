import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';

class SocialMediaModel {
  String? provider;
  String? email;
  String? image;
  String? name;
  String? idToken;
  String? uid;
  String? rawNonce;
  String? phone;

  SocialMediaModel({
    this.provider,
    this.email,
    this.name,
    this.idToken,
    this.uid,
    this.image,
    this.rawNonce,
    this.phone,
  });

  printData() {
    log('Provider >>> $provider');
    log('Image >>> $image');
    log('Email >>> $email');
    log('Name >>> $name');
    log('ID Token >>> $idToken');
    log('uid >>> $uid');
    log('nonce >>> $rawNonce');
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['provider'] = provider;
    data['firebase_id_token'] = idToken;
    data['full_name'] = name;
    data['avatar'] = image;
    data['email'] = email;
    data['phone'] = phone;
    data['uid'] = uid;
    data['nonce'] = rawNonce;
    data['fcm_token'] = await FirebaseMessaging.instance.getToken();
    return data;
  }
}
