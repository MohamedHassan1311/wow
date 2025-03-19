import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class CategoriesModel extends SingleMapper {
  String? message;
  int? statusCode;
  List<CategoryModel>? data;
  Meta? meta;

  CategoriesModel({
    this.message,
    this.statusCode,
    this.data,
    this.meta,
  });

  @override
  Map<String, dynamic> toJson() => {
        "message": message,
        "status_code": statusCode,
        "pagination": meta?.toJson(),
        "data": data != null
            ? List<dynamic>.from(data!.map((x) => x.toJson()))
            : [],
      };

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['status_code'];
    meta =
        json['pagination'] != null ? Meta.fromJson(json['pagination']) : null;

    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(CategoryModel.fromJson(v));
      });
    }
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CategoriesModel.fromJson(json);
  }
}

class CategoryModel extends SingleMapper {
  int? id;
  String? name;
  String? description;
  String? type;
  String? subChild;
  String? image;
  bool? isComingSoon;
  List<CategoryModel>? levels;

  ///If From Vendor
  int? vendorId;
  bool isVendor;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.type,
    this.subChild,
    this.image,
    this.isComingSoon,
    this.levels,
    this.vendorId,
    this.isVendor = false,
  });

  CategoryModel.fromJson(Map<String, dynamic> json,
      {this.vendorId, this.isVendor = true}) {
    id = json["id"];
    image = json["image"];
    name = json["name"];
    description = json["desc"];
    type = json["type"];
    subChild = json["sub_child"];
    isComingSoon = json["is_coming_soon"];
    levels = json["is_coming_soon"];
    if (json['levels'] != null) {
      levels = [];
      json['levels'].forEach((v) {
        levels!.add(CategoryModel.fromJson(v));
      });
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        "desc": description,
        "type": type,
        "sub_child": subChild,
        "is_coming_soon": isComingSoon,
        "levels": levels != null
            ? List<dynamic>.from(levels!.map((x) => x.toJson()))
            : [],
        "vendor_id": vendorId,
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return CategoryModel.fromJson(json);
  }
}
