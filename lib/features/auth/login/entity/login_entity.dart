import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class LoginEntity {
  TextEditingController? email;
  TextEditingController? password;

  String? emailError;
  String? passwordError;

  LoginEntity({
    this.email,
    this.password,
    this.emailError,
    this.passwordError,
  });

  LoginEntity copyWith({
    String? emailError,
    String? passwordError,
  }) {
    this.emailError = emailError ?? this.emailError;
    this.passwordError = passwordError ?? this.passwordError;

    return this;
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = emailError == "" ? email?.text.trim() : null;
    data['password'] = passwordError == "" ? password?.text.trim() : null;
    data['fcm_token'] =await FirebaseMessaging.instance.getToken();
    return data;
  }
}
