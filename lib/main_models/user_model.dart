import 'package:wow/data/config/mapper.dart';
import 'package:intl/intl.dart';

import 'custom_field_model.dart';

class UserModel extends SingleMapper {
  int? id;
  String? name;
  String? image;
  String? fname;
  String? lname;
  String? nickname;
  String? profileImage;
  String? email;
  String? balance;
  String? countryCode;
  String? phone;
  String? phoneCode;
  DateTime? dob;
  String? gender;
  int? subscription;
  CustomFieldModel? socialStatus;
  CustomFieldModel? regionId;
  CustomFieldModel? nationalityId;
  CustomFieldModel? cityId;
  CustomFieldModel? countryId;

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
  double? wallet;
  int? points;
  String? type;
  String? gfName;
  String? glName;
  String? gPhoneNumber;
  String? otherGuardian;
  CustomFieldModel? otherNationalityId;
  int? numOfSons;
  DateTime? dop;

  UserModel({
    this.id,
    this.name,
    this.image,
    this.fname,
    this.lname,
    this.nickname,
    this.email,
    this.profileImage,
    this.balance,
    this.countryCode,
    this.phone,
    this.phoneCode,
    this.dob,
    this.gender,
    this.dop,
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
    this.gfName,
    this.glName,
    this.gPhoneNumber,
    this.otherGuardian,
    this.nationalityId,
    this.otherNationalityId,
    this.numOfSons,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    print(json['dop']);
    id = json['id'];
    name = json['fname'] + " " + json['lname'];
    fname = json['fname'];
    lname = json['lname'];
    image = json['image'];
    glName = json['glName'];
    gfName = json['gfName'];
    gPhoneNumber = json['gPhoneNumber'];
    otherGuardian = json['otherGuardian'];
    nickname = json['nickname'];
    balance = json['balance'];
    profileImage = json['image'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    phoneCode = json['phone_code'];
    gender = json['gender'];
    dop = json['dob'] != null
        ? DateFormat('d/M/yyyy').parse(json['dob'])
        : DateTime.now();
    subscription = json['subscription'];
    socialStatus = (json['social_status'] != null&&json['social_status'] != 1)
        ? CustomFieldModel.fromJson(json['social_status'])
        : CustomFieldModel(name: "no Data");
    regionId =json['region']!=null? CustomFieldModel.fromJson(json['region']) : CustomFieldModel(name: "no Data");
    cityId = json['city'] != null
        ? CustomFieldModel.fromJson(json['city'])
        : CustomFieldModel(name: "no Data");
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
    wallet = double.tryParse(json['wallet']?.toString() ?? '0.0');
    points = json['points'];
    type = json['type'];
    countryId = json['country'] != null
        ? CustomFieldModel.fromJson(json['country'])
        : CustomFieldModel(name: "no Data");

    nationalityId = json['country'] != null
        ? CustomFieldModel.fromJson(json['nationality'])
        : CustomFieldModel(name: "no Data");
    otherNationalityId = json['other_nationality'] != null
        ? CustomFieldModel.fromJson(json['other_nationality'])
        : CustomFieldModel(name: "no Data");
    numOfSons = json['num_of_sons'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fname'] = fname;
    data['lname'] = lname;
    data['gfName'] = gfName;
    data['image'] = profileImage;
    data['glName'] = glName;
    data['gPhoneNumber'] = gPhoneNumber;
    data['otherGuardian'] = otherGuardian;
    data['nickname'] = nickname;
    data['email'] = email;
    data['phone_code'] = phoneCode;
    data['country_code'] = countryCode;
    data['phone'] = phone;
    data['gender'] = gender;
    data['dob'] = dop;
    data['image'] = image;

    data['subscription'] = subscription;
    data['social_status'] = socialStatus?.toJson();
    data['region_id'] = regionId?.toJson();
    data['city'] = cityId?.toJson();
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
    data['country'] = countryId?.toJson();
    data['wallet'] = wallet;
    data['points'] = points;
    data['type'] = type;
    data['nationality'] = nationalityId?.toJson();
    data['other_nationality'] = otherNationalityId?.toJson();
    data['num_of_sons'] = numOfSons;

    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
