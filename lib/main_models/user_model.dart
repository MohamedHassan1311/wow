import 'package:wow/data/config/mapper.dart';
import 'package:intl/intl.dart';
import 'package:wow/main_models/user_model_validation.dart';

import 'custom_field_model.dart';

class UserModel extends SingleMapper {
  int? id;
  String? name;
  String? image;
  String? fname;
  String? lname;
  String? nickname;
  int? isVerified;
  int? isFavourit;
  int? isIntersted;
  int? age;
  String? profileImage;
  String? email;
  String? balance;
  String? countryCode;
  String? phone;
  String? phoneCode;
  DateTime? dob;
  String? gender;
  int? subscription;
  int? height;
  int? weight;
  CustomFieldModel? socialStatus;
  CustomFieldModel? regionId;
  CustomFieldModel? nationalityId;
  CustomFieldModel? cityId;
  CustomFieldModel? countryId;
  CustomFieldModel? education;
  CustomFieldModel? education2;
  String? job;
  String? job2;
  CustomFieldModel? bodyType;
  CustomFieldModel? skinColor;
  CustomFieldModel? tribe;
  String? otherTribe;
  CustomFieldModel? sect;
  CustomFieldModel? culture;
  CustomFieldModel? health;
  CustomFieldModel? lifestyle;
  List<CustomFieldModel>? marriageCondition;
  String? otherConditionText;

  String? personalInfo;
  String? partenrInfo;
  String? salary;
  String? identityFile;
  CustomFieldModel? accountType;
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
  int? verifyPayment;
  List<int>? languages;
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
  String? grelation;
  String? otherGuardian;
  CustomFieldModel? otherNationalityId;
  CustomFieldModel? hijab;
  CustomFieldModel? abaya;

  int? numOfSons;
  DateTime? dop;
  UserModelValidation? validation;
  bool? thereIsValidation;
  int? number_of_chats;
  int? number_of_likes;
  int? number_of_interst;
  String? editFee;
  bool? can_view_guardian_info;

  int? proposal_suspend;

  UserModel(
      {this.id,
      this.name,
      this.image,
      this.fname,
      this.lname,
      this.nickname,
      this.isFavourit,
      this.email,
      this.age,
      this.marriageCondition,
      this.otherConditionText,
      this.profileImage,
      this.balance,
      this.countryCode,
      this.phone,
      this.phoneCode,
      this.editFee,
      this.dob,
      this.gender,
      this.dop,
      this.subscription,
      this.socialStatus,
      this.languages,
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
      this.isIntersted,
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
      this.salary,
      this.nationalityId,
      this.otherNationalityId,
      this.numOfSons,
      this.partenrInfo,
      this.weight,
      this.height,
      this.education,
      this.education2,
      this.tribe,
      this.otherTribe,
      this.skinColor,
      this.bodyType,
      this.job,
      this.personalInfo,
      this.validation,
      this.sect,
      this.culture,
      this.health,
      this.lifestyle,
      this.can_view_guardian_info,
      this.number_of_chats,
      this.number_of_likes,
      this.abaya,
      this.number_of_interst,
      this.proposal_suspend});

  UserModel.fromJson(Map<String, dynamic> json) {
    print(json['dop']);
    id = json['id'];
    name = json['fname'].toString() + " " + json['lname'].toString();
    fname = json['fname'];
    lname = json['lname'];
    image = json['image'];
    grelation = json['grelation'];
    gfName = json['gfname']?.toString();
    glName = json['glname']?.toString();
    gPhoneNumber = json['gphone']?.toString();
    otherGuardian = json['otherGuardian'];
    nickname = json['nickname'];
    balance = json['wallet'].toString();
    age = json['age'];
    profileImage = json['image'];
    email = json['email'];
    countryCode = json['country_code'];
    phone = json['phone'];
    phoneCode = json['phone_code'];
    gender = json['gender'];
    editFee = json['edit_fee'].toString();
    number_of_interst = json['number_of_likes'];
    can_view_guardian_info = json['can_view_guardian_info'];
    dob = DateTime.tryParse(json['dob'] ?? '') ?? DateTime.now();

    subscription = json['subscription'];
    socialStatus =
        (json['social_status'] != null && json['social_status'] is! int)
            ? CustomFieldModel.fromJson(json['social_status'])
            : CustomFieldModel(name: "no Data");

    hijab = (json['hijab'] != null && json['hijab'] is! int)
        ? CustomFieldModel.fromJson(json['hijab'])
        : CustomFieldModel(name: "no Data");
    abaya = (json['abaya'] != null && json['abaya'] is! int)
        ? CustomFieldModel.fromJson(json['abaya'])
        : CustomFieldModel(name: "no Data");
    regionId = json['region'] != null
        ? CustomFieldModel.fromJson(json['region'])
        : CustomFieldModel(name: "no Data");
    cityId = json['city'] != null
        ? CustomFieldModel.fromJson(json['city'])
        : CustomFieldModel(name: "no Data");

    marriageCondition = json['marriage_condition'] != null
        ? List<CustomFieldModel>.from(
            json['marriage_condition'].map((e) => CustomFieldModel.fromJson(e)))
        : [];
    otherConditionText = json['other_condition'];

    partenrInfo = json['about_partner'];
    personalInfo = json['about_me'];
    salary = json['salary'];
    //[ERROR:flutter/runtime/dart_vm_initializer.cc(40)] Unhandled Exception: type 'String' is not a subtype of type 'int' in type cast

    languages = json['language'] != null
        ? List<int>.from(json['language'].map((e) => int.parse(e.toString())))
        : [];

    weight = int.tryParse(json['weight']?.toString() ?? '0');
    height = int.tryParse(json['height']?.toString() ?? '0');
    education = json['education'] != null &&
            json['education'] is! int &&
            json['education'] is! String
        ? CustomFieldModel.fromJson(json['education'])
        : CustomFieldModel(name: "no Data");
    education2 = json['education_2'] != null &&
            json['education_2'] is! int &&
            json['education_2'] is! String
        ? CustomFieldModel.fromJson(json['education_2'])
        : CustomFieldModel(name: "no Data");
    tribe = json['tribe'] != null &&
            json['tribe'] is! int &&
            json['tribe'] is! String
        ? CustomFieldModel.fromJson(json['tribe'])
        : CustomFieldModel(name: "no Data");

    otherTribe = json['otherTribe'];

    skinColor = json['complexion'] != null
        ? CustomFieldModel.fromJson(json['complexion'])
        : CustomFieldModel(name: "no Data");

    bodyType = json['body_type'] != null
        ? CustomFieldModel.fromJson(json['body_type'])
        : CustomFieldModel(name: "no Data");

    job = json['job_title'];
    isFavourit = json['is_favourite'] == false ? 0 : 1;
    isIntersted = json['is_intersted'] == false ? 0 : 1;
    sect = json['religion'] != null
        ? CustomFieldModel.fromJson(json['religion'])
        : CustomFieldModel(name: "no Data");

    identityFile = json['identity_file'];
    accountType = json['account_type'] != null && json['account_type'] is Map
        ? CustomFieldModel.fromJson(json['account_type'])
        : CustomFieldModel(name: "no Data");
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
    number_of_interst = json['number_of_likes'];
    countryId = json['country'] != null
        ? CustomFieldModel.fromJson(json['country'])
        : CustomFieldModel(name: "no Data");

    nationalityId = json['country'] != null
        ? CustomFieldModel.fromJson(json['nationality'])
        : CustomFieldModel(name: "no Data");
    otherNationalityId = json['other_nationality'] != null
        ? CustomFieldModel.fromJson(json['other_nationality'])
        : CustomFieldModel(name: "no Data");

    culture = json['culture'] != null
        ? CustomFieldModel.fromJson(json['culture'])
        : CustomFieldModel(name: "no Data");
    health = json['health'] != null
        ? CustomFieldModel.fromJson(json['health'])
        : CustomFieldModel(name: "no Data");
    lifestyle = json['lifestyle'] != null
        ? CustomFieldModel.fromJson(json['lifestyle'])
        : CustomFieldModel(name: "no Data");
    accountType = json['account_type'] != null && json['account_type'] is Map
        ? CustomFieldModel.fromJson(json['account_type'])
        : CustomFieldModel(name: "no Data");

    number_of_chats = json['number_of_chats'];
    number_of_likes = json['number_of_likes'];
    proposal_suspend = json['proposal_suspend'];
    numOfSons = json['num_of_sons'];
    if (json['client_data_validation'] != null) {
      validation = UserModelValidation();
      thereIsValidation = true;
      validation!.assignFromValidationList(json['client_data_validation']);
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fname'] = fname;
    data['lname'] = lname;
    data['age'] = age;
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
    data['dob'] = dop?.toIso8601String();

    data['image'] = image;
    data['number_of_chats'] = number_of_chats;
    data['number_of_likes'] = number_of_likes;
    data['number_of_likes'] = number_of_interst;
    data['proposal_suspend'] = proposal_suspend;
    data['is_favourit'] = isFavourit;
    data['language'] = languages;
    data['salary'] = salary;
    data['subscription'] = subscription;
    data['marriage_condition'] =
        marriageCondition?.map((e) => e.toJson()).toList();
    data['other_condition'] = otherConditionText;
    data['social_status'] = socialStatus?.toJson();
    data['region_id'] = regionId?.toJson();
    data['city'] = cityId?.toJson();
    data['identity_file'] = identityFile;
    data['account_type'] = accountType?.toJson();
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
    data['balance'] = balance;
    data['about_me'] = personalInfo;
    data['about_partner'] = partenrInfo;
    data['weight'] = weight;
    data['height'] = height;
    data['education'] = education?.toJson();
    data['abaya'] = abaya?.toJson();
    data['hijab'] = hijab?.toJson();
    data['job_title'] = job;
    data['body_type'] = bodyType?.toJson();
    data['complexion'] = skinColor?.toJson();
    data['tribe'] = tribe?.toJson();
    data['otherTribe'] = otherTribe;
    data['religion'] = sect?.toJson();
    data['culture'] = culture?.toJson();
    data['health'] = health?.toJson();
    data['lifestyle'] = lifestyle?.toJson();
    data['account_type'] = accountType?.toJson();
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return UserModel.fromJson(json);
  }
}
