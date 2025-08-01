import 'package:wow/main_models/user_model.dart';

import '../../../data/config/mapper.dart';
import '../../../main_models/meta.dart';

class NotificationsModel extends SingleMapper {
  String? status;
  String? message;
  String? unreadCount;
  List<NotificationModel>? data;
  Meta? meta;

  NotificationsModel({this.status, this.message, this.data, this.unreadCount});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    message = json["data"]["unread_count"].toString();
    unreadCount = json["data"]["unread_count"].toString();
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;

    data = json["data"] == null
        ? []
        : List<NotificationModel>.from(json["data"]['notifications']!
            .map((x) => NotificationModel.fromJson(x)));
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "meta": meta?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return NotificationsModel.fromJson(json);
  }
}

class NotificationModel extends SingleMapper {
  String? id;
  String? createdTime;
  DateTime? createdAt;
  bool? isRead;
  String? image;
  String? key;
  String? title;
  UserModel? user;
  String? route;
  String? checkoutId;
  String? body;
  int? keyId;

  NotificationModel({
    this.id,
    this.createdTime,
    this.createdAt,
    this.isRead,
    this.image,
    this.key,
    this.title,
    this.body,
    this.user,
    this.route,
    this.checkoutId,
    this.keyId,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdTime = json['created_time'];
    createdAt = DateTime.parse(json['created_at']);
    isRead = json['read_at'] != null;
    image = json['image'];
    key = json['key'];
    title = json["data"]['title'];
    body = json['data']['body'];
    route = json["data"]['routeName'];
    checkoutId = json["data"]['checkout_id'];
    user = json['data']['sender'] != null
        ? UserModel.fromJson(json['data']['sender'])
        : null;
    keyId = json['key_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['key_id'] = keyId;
    data['created_time'] = createdTime;
    data['created_at'] = createdAt;
    data['is_readed'] = isRead;
    data['image'] = image;
    data['key'] = key;
    data['title'] = title;
    data['body'] = body;
    return data;
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return NotificationModel.fromJson(json);
  }
}
