import 'package:wow/data/config/mapper.dart';
import '../../../main_models/meta.dart';

class AddressesModel extends SingleMapper {
  String? message;
  int? code;
  List<AddressModel>? data;
  Meta? meta;

  AddressesModel({this.message, this.code, this.data});

  AddressesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(AddressModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['code'] = code;
    data['meta'] = meta?.toJson();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return AddressesModel.fromJson(json);
  }
}

class AddressModel extends SingleMapper {
  int? id;
  double? lat, long;
  String? addressName, addressDetails, block, landmark, addressType, phone;
  String? createdAt;

  AddressModel(
      {this.id,
      this.lat,
      this.long,
      this.addressName,
      this.addressDetails,
      this.addressType,
      this.block,
      this.landmark,
      this.phone,
      this.createdAt});

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    addressName = json['address_name'];
    addressDetails = json['address_details'];
    long = double.tryParse(json['long']?.toString() ?? "0");
    lat = double.tryParse(json['lat']?.toString() ?? "0");
    addressType = json['address_type'];
    block = json['block'];
    landmark = json['landmark'];
    phone = json['phone']?.toString();
    createdAt = json['created_at'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['address_name'] = addressName;
    data['address_details'] = addressDetails;
    data['long'] = long;
    data['lat'] = lat;
    data['block'] = block;
    data['landmark'] = landmark;
    data['phone'] = phone;
    data['created_at'] = createdAt;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return AddressModel.fromJson(json);
  }
}

enum AddressType { home, work, other }
