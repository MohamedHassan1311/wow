class VerificationModel {
  String? email;
  String? code;
  String? phone;
  String? countryCode;

  bool fromRegister;
  bool ?fromLogin;

  bool fromForgetPass;
  VerificationModel({
    this.email,
    this.code,
    this.phone,
    this.countryCode,
    this.fromLogin,
    this.fromRegister = true,
    this.fromForgetPass = true,
  });
  bool isEmpty() => email == "";

  Map<String, dynamic> toJson({bool withCode = true}) => {
        "email": email,
        if (withCode) "verification_code": code,
      };
}
