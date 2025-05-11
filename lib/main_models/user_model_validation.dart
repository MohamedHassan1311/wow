class UserModelValidation {
  String? id;
  String? name;
  String? fname;
  String? lname;
  String? nickname;
  String? profileImage;
  String? email;
  String? balance;
  String? countryCode;
  String? phone;
  String? phoneCode;
  String? dob;
  String? gender;
  String? subscription;
  String? height;
  String? weight;
  String? socialStatus;
  String? regionId;
  String? nationalityId;
  String? cityId;
  String? salary;
  String? countryId;
  String? education;
  String? education2;
  String? job;
  String? bodyType;
  String? skinColor;
  String? tribe;
  String? sect;
  String? personalInfo;
  String? partenrInfo;
  String? identityFile;
  String? accountType;
  String? notes;
  String? verified;
  String? blocked;
  String? online;
  String? pausedOn;
  String? expiryDate;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? status;
  String? isVerified;
  String? verifyPayment;
  String? languages;
  String? deletionDate;
  String? deletionReason;
  String? emailVerified;
  String? verificationCode;
  String? invitationCode;
  String? fcmToken;
  String? wallet;
  String? points;
  String? type;
  String? gfName;
  String? glName;
  String? gPhoneNumber;
  String? otherGuardian;
  String? otherNationalityId;
  String? numOfSons;
  String? dop;

  void assignFromValidationList(List<dynamic> validationList) {
    for (var item in validationList) {
      if (item['status'] != 'rejected') continue;

      final field = item['field_name'];
      final error = item['note'] ?? 'Invalid value';

      switch (field) {
        case 'id': id = error; break;
        case 'fname': fname = error; break;
        case 'lname': lname = error; break;
        case 'nickname': nickname = error; break;
        case 'image':
        case 'profileImage': profileImage = error; break;
        case 'email': email = error; break;
        case 'balance': balance = error; break;
        case 'country_code': countryCode = error; break;
        case 'phone': phone = error; break;
        case 'phone_code': phoneCode = error; break;
        case 'dob': dob = error; break;
        case 'salary': salary = error; break;
        case 'dop': dop = error; break;
        case 'gender': gender = error; break;
        case 'subscription': subscription = error; break;
        case 'height': height = error; break;
        case 'weight': weight = error; break;
        case 'social_status': socialStatus = error; break;
        case 'region': regionId = error; break;
        case 'nationality': nationalityId = error; break;
        case 'other_nationality': otherNationalityId = error; break;
        case 'city': cityId = error; break;
        case 'country': countryId = error; break;
        case 'education': education = error; break;
        case 'education2': education2 = error; break;
        case 'job': job = error; break;
        case 'body_type': bodyType = error; break;
        case 'complexion': skinColor = error; break;
        case 'tribe': tribe = error; break;
        case 'religion': sect = error; break;
        case 'about_me': personalInfo = error; break;
        case 'about_partner': partenrInfo = error; break;
        case 'identity_file': identityFile = error; break;
        case 'account_type': accountType = error; break;
        case 'notes': notes = error; break;
        case 'verified': verified = error; break;
        case 'blocked': blocked = error; break;
        case 'online': online = error; break;
        case 'paused_on': pausedOn = error; break;
        case 'expiry_date': expiryDate = error; break;
        case 'created_at': createdAt = error; break;
        case 'updated_at': updatedAt = error; break;
        case 'deleted_at': deletedAt = error; break;
        case 'status': status = error; break;
        case 'is_verified': isVerified = error; break;
        case 'verify_payment': verifyPayment = error; break;
        case 'languages': languages = error; break;
        case 'deletion_date': deletionDate = error; break;
        case 'deletion_reason': deletionReason = error; break;
        case 'email_verified': emailVerified = error; break;
        case 'verification_code': verificationCode = error; break;
        case 'invitation_code': invitationCode = error; break;
        case 'fcm_token': fcmToken = error; break;
        case 'wallet': wallet = error; break;
        case 'points': points = error; break;
        case 'type': type = error; break;
        case 'gfName': gfName = error; break;
        case 'glName': glName = error; break;
        case 'gPhoneNumber': gPhoneNumber = error; break;
        case 'otherGuardian': otherGuardian = error; break;
        case 'num_of_sons': numOfSons = error; break;
        default:
          print("Unhandled validation field: $field");
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fname": fname,
      "lname": lname,
      "nickname": nickname,
      "profileImage": profileImage,
      "email": email,
      "balance": balance,
      "countryCode": countryCode,
      "phone": phone,
      "phoneCode": phoneCode,
      "dob": dob,
      "dop": dop,
      "gender": gender,
      "subscription": subscription,
      "height": height,
      "weight": weight,
      "socialStatus": socialStatus,
      "regionId": regionId,
      "nationalityId": nationalityId,
      "otherNationalityId": otherNationalityId,
      "cityId": cityId,
      "countryId": countryId,
      "education": education,
      "job": job,
      "bodyType": bodyType,
      "skinColor": skinColor,
      "tribe": tribe,
      "sect": sect,
      "personalInfo": personalInfo,
      "partenrInfo": partenrInfo,
      "identityFile": identityFile,
      "accountType": accountType,
      "notes": notes,
      "verified": verified,
      "blocked": blocked,
      "online": online,
      "pausedOn": pausedOn,
      "expiryDate": expiryDate,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "deletedAt": deletedAt,
      "status": status,
      "isVerified": isVerified,
      "verifyPayment": verifyPayment,
      "languages": languages,
      "deletionDate": deletionDate,
      "deletionReason": deletionReason,
      "emailVerified": emailVerified,
      "verificationCode": verificationCode,
      "invitationCode": invitationCode,
      "fcmToken": fcmToken,
      "wallet": wallet,
      "points": points,
      "type": type,
      "gfName": gfName,
      "glName": glName,
      "gPhoneNumber": gPhoneNumber,
      "otherGuardian": otherGuardian,
      "numOfSons": numOfSons,
    };
  }
}
