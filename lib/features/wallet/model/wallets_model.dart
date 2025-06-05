import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';
import 'wallet_model.dart';

class WalletsModel extends SingleMapper {
  final List<WalletModel>? data;
  final Meta? meta;

  WalletsModel({
    this.data,
    this.meta,
  });

  factory WalletsModel.fromJson(Map<String, dynamic> json) {
    return WalletsModel(
      data: json['data'] != null
          ? List<WalletModel>.from(
              json['data'].map((x) => WalletModel.fromJson(x)))
          : null,
      meta: json['meta'] != null ? Meta.fromJson(json['meta']) : null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'data': data?.map((x) => x.toJson()).toList(),
      'meta': meta?.toJson(),
    };
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return WalletsModel.fromJson(json);
  }
} 