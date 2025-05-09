import 'package:flutter/cupertino.dart';

import '../../../../main_models/custom_field_model.dart';

class ContactWithUsEntity {
  TextEditingController? name, email, phone, message;
  CustomFieldModel? country;

  String? nameError, emailError, phoneError, countryError;
  String? messageError;

  ContactWithUsEntity({
    this.name,
    this.email,
    this.phone,
    this.country,
    this.message,
    this.nameError,
    this.emailError,
    this.phoneError,
    this.countryError,
    this.messageError,
  });

  ContactWithUsEntity copyWith({
    String? name,
    String? email,
    String? phone,
    CustomFieldModel? country,
    String? message,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? countryError,
    String? messageError,
  }) {
    this.country = country ?? this.country;
    this.nameError = nameError ?? this.nameError;
    this.emailError = emailError ?? this.emailError;
    this.phoneError = phoneError ?? this.phoneError;
    this.countryError = countryError ?? this.countryError;
    this.messageError = messageError ?? this.messageError;
    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = nameError == "" ? name?.text.trim() : null;
    data['email'] = emailError == "" ? email?.text.trim() : null;
    data['phone'] = phoneError == "" ? phone?.text.trim() : null;
    data['country_id'] = countryError == "" ? country?.id : null;
    data['message'] = messageError == "" ? message?.text.trim() : null;
    return data;
  }
}
