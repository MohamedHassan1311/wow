import 'package:flutter/cupertino.dart';

class ResetPasswordEntity {
  TextEditingController? password;
  TextEditingController? confirmPassword;
  TextEditingController? email;

  String? passwordError;
  String? confirmPasswordError;

  ResetPasswordEntity({
    this.password,
    this.email,
    this.confirmPassword,
    this.passwordError,
    this.confirmPasswordError,
  });

  ResetPasswordEntity copyWith({
    String? passwordError,
    String? confirmPasswordError,
  }) {
    this.passwordError = passwordError ?? this.passwordError;
    this.confirmPasswordError =
        confirmPasswordError ?? this.confirmPasswordError;

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = passwordError == "" ? email?.text.trim() : null;
    data['password'] = passwordError == "" ? password?.text.trim() : null;
    data['newPassword'] = confirmPasswordError == "" ? confirmPassword?.text.trim() : "";
    return data;
  }
}
