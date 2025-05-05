import 'package:wow/data/config/mapper.dart';

class UserModel extends SingleMapper {
  int? id;
  String? name;
  String? fname;
  String? lname;
  String? profileImage;
  String? email;
  String? balance;
  String? countryCode;
  String? phone;
  String? dob;
  String? gender;
  int? subscription;
  int? socialStatus;
  int? regionId;
  int? cityId;
  String? identityFile;
  String? accountType;
  String? notes;
  int? verified;
  int? blocked;
  int? online;
  String? pausedOn;
  String? expiryDate;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? status;
  int? isVerified;
  int? verifyPayment;
  String? deletionDate;
  String? deletionReason;
  int? emailVerified;
  String? verificationCode;
  String? invitationCode;
  String? fcmToken;
  int? countryId;
  double? wallet;
  int? points;
  String? type;
  int? nationalityId;
  int? otherNationalityId;
  int? numOfSons;

  UserModel({
    this.id,
    this.name,
    this.fname,
    this.lname,
    this.email,
    this.profileImage,
    this.balance,
    this.countryCode,
    this.phone,
    this.dob,
    this.gender,
    this.subscription,
    this.socialStatus,
    this.regionId,
    this.cityId,
    this.identityFile,
    this.accountType,
    this.notes,
    this.verified,
    this.blocked,
    this.online,
    this.pausedOn,
    this.expiryDate,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.status,
    this.isVerified,
    this.verifyPayment,
    this.deletionDate,
    this.deletionReason,
    this.emailVerified,
    this.verificationCode,
    this.invitationCode,
    this.fcmToken,
    this.countryId,
    this.wallet,
    this.points,
    this.type,
    this.nationalityId,
    this.otherNationalityId,
    this.numOfSons,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['fname']+" "+json['lname'];
    fname = json['fname'];
    lname = json['lname'];
    balance = json['balance'];
    profileImage = json['profileImage'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    dob = json['dob'];
    gender = json['gender'];
    subscription = json['subscription'];
    socialStatus = json['social_status'];
    regionId = json['region_id'];
    cityId = json['city_id'];
    identityFile = json['identity_file'];
    accountType = json['account_type'];
    notes = json['notes'];
    verified = json['verified'];
    blocked = json['blocked'];
    online = json['online'];
    pausedOn = json['paused_on'];
    expiryDate = json['expiry_date'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    status = json['status'];
    isVerified = json['is_verified'];
    verifyPayment = json['verify_payment'];
    deletionDate = json['deletion_date'];
    deletionReason = json['deletion_reason'];
    emailVerified = json['email_verified'];
    verificationCode = json['verification_code'];
    invitationCode = json['invitation_code'];
    fcmToken = json['fcm_token'];
    countryId = json['country_id'];
    wallet = double.tryParse(json['wallet']?.toString() ?? '0.0');
    points = json['points'];
    type = json['type'];
    nationalityId = json['nationality_id'];
    otherNationalityId = json['other_nationality_id'];
    numOfSons = json['num_of_sons'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fname'] = fname;
    data['lname'] = lname;
    data['email'] = email;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['dob'] = dob;
    data['gender'] = gender;
    data['subscription'] = subscription;
    data['social_status'] = socialStatus;
    data['region_id'] = regionId;
    data['city_id'] = cityId;
    data['identity_file'] = identityFile;
    data['account_type'] = accountType;
    data['notes'] = notes;
    data['verified'] = verified;
    data['blocked'] = blocked;
    data['online'] = online;
    data['paused_on'] = pausedOn;
    data['expiry_date'] = expiryDate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['status'] = status;
    data['is_verified'] = isVerified;
    data['verify_payment'] = verifyPayment;
    data['deletion_date'] = deletionDate;
    data['deletion_reason'] = deletionReason;
    data['email_verified'] = emailVerified;
    data['verification_code'] = verificationCode;
    data['invitation_code'] = invitationCode;
    data['fcm_token'] = fcmToken;
    data['country_id'] = countryId;
    data['wallet'] = wallet;
    data['points'] = points;
    data['type'] = type;
    data['nationality_id'] = nationalityId;
    data['other_nationality_id'] = otherNationalityId;
    data['num_of_sons'] = numOfSons;

    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
