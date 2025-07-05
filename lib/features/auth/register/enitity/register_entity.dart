import 'package:flutter/cupertino.dart';

import '../../../../main_models/custom_field_model.dart';

class RegisterEntity {
  TextEditingController? name,nickName, email, phone, password, confirmPassword;
  String? country;

  String? nameError, emailError, phoneError, countryError;
  String? passwordError, confirmPasswordError;

  RegisterEntity({
    this.name,
    this.email,
    this.nickName,
    this.phone,
    this.country,
    this.password,
    this.confirmPassword,
    this.nameError,
    this.emailError,
    this.phoneError,
    this.countryError,
    this.passwordError,
    this.confirmPasswordError,
  });

  RegisterEntity copyWith({
    String? name,
    String? email,
    String? nickName,
    String? phone,
    String? country,
    String? password,
    String? confirmPassword,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? countryError,
    String? passwordError,
    String? confirmPasswordError,
  }) {
    this.country = country ?? this.country;
    this.nickName = this.nickName;
    this.nameError = nameError ?? this.nameError;
    this.emailError = emailError ?? this.emailError;
    this.phoneError = phoneError ?? this.phoneError;
    this.countryError = countryError ?? this.countryError;
    this.passwordError = passwordError ?? this.passwordError;
    this.confirmPasswordError =
        confirmPasswordError ?? this.confirmPasswordError;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fname'] = nameError == "" ? name?.text.trim() : "fname";
    data['lname'] = nameError == "" ? name?.text.trim() : "lname";
    data['email'] = emailError == "" ? email?.text.trim() : null;
    data['phone'] = phoneError == "" ? phone?.text.trim() : null;
    data['country_code'] = country!.replaceAll("+", "") ;
    data['password'] = passwordError == "" ? password?.text.trim() : null;
    data['invitation_code'] =  nickName!.text.trim().isEmpty?"WOW":nickName!.text.trim();
    data['confirm_password'] = confirmPasswordError == "" ? confirmPassword?.text.trim() : "";
    return data;
  }
}
