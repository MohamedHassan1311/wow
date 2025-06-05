import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';
import 'subscription_model.dart';

class SubscriptionsModel extends SingleMapper {
  final List<SubscriptionModel>? data;
  final Meta? meta;

  SubscriptionsModel({
    this.data,
    this.meta,
  });

  factory SubscriptionsModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionsModel(
      data: json['data'] != null
          ? List<SubscriptionModel>.from(
              json['data'].map((x) => SubscriptionModel.fromJson(x)))
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
    return SubscriptionsModel.fromJson(json);
  }
}

class Meta {
  final int? currentPage;
  final int? pagesCount;
  final int? total;

  Meta({
    this.currentPage,
    this.pagesCount,
    this.total,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      currentPage: json['current_page'],
      pagesCount: json['pages_count'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'pages_count': pagesCount,
      'total': total,
    };
  }
} 