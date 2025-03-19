import 'package:flutter/cupertino.dart';
import 'package:wow/features/addresses/model/addresses_model.dart';
import 'package:wow/features/maps/models/location_model.dart';

class AddressEntity {
  int? id;
  TextEditingController? name, details, phone, block, landmark;
  LocationModel? location;
  AddressType? type;

  String? nameError, detailsError, phoneError, typeError, blockError;
  AddressEntity({
    this.id,
    this.location,
    this.name,
    this.details,
    this.phone,
    this.type,
    this.block,
    this.landmark,
    this.nameError,
    this.detailsError,
    this.phoneError,
    this.typeError,
    this.blockError,
  });

  AddressEntity copyWith({
    int? id,
    LocationModel? location,
    AddressType? type,
    String? nameError,
    String? detailsError,
    String? phoneError,
    String? typeError,
    String? blockError,
  }) {
    this.id = id ?? this.id;
    this.location = location ?? this.location;
    this.type = type ?? this.type;
    this.nameError = nameError ?? this.nameError;
    this.detailsError = detailsError ?? this.detailsError;
    this.phoneError = phoneError ?? this.phoneError;
    this.typeError = typeError ?? this.typeError;
    this.blockError = blockError ?? this.blockError;

    return this;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = location?.latitude;
    data['long'] = location?.longitude;
    data['name'] = nameError == "" ? name?.text.trim() : null;
    data['details'] = detailsError == "" ? details?.text.trim() : null;
    data['phone'] = phoneError == "" ? phone?.text.trim() : null;
    data['type'] = typeError == "" ? type?.name : null;
    data['block'] = blockError == "" ? block?.text.trim() : null;
    if (landmark?.text.trim() != null && landmark!.text.trim().isNotEmpty) {
      data['landmark'] = landmark?.text.trim();
    }
    return data;
  }
}
