import 'package:wow/data/config/mapper.dart';
import 'package:wow/main_blocs/user_bloc.dart';
import 'package:wow/main_models/user_model.dart';

import '../../../main_models/meta.dart';

class ChatsModel extends SingleMapper {
  String? message;
  int? code;
  List<ChatModel>? data;
  Meta? meta;

  ChatsModel({this.message, this.code, this.data});

  ChatsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    code = json['code'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <ChatModel>[];
      json['data'].forEach((v) {
        data!.add(ChatModel.fromJson(v));
      });
    }
  }

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
    return ChatsModel.fromJson(json);
  }
}

class ChatModel {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? patientId;
  final int? doctorId;
  final int? senderId;

  final int? readCount;
  final dynamic message;
  final int? patientRead;
  final int? userRead;
  final int? status;

  final UserModel? user;
  final UserModel? me;

  ChatModel({
    this.id,
    this.createdAt,
    this.senderId,
    this.updatedAt,
    this.patientId,
  this.doctorId,
    this.readCount,
    this.message,
    this.patientRead,
    this.userRead,
    this.user,
    this.status,
    this.me,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, {bool fromCreate=false}) => ChatModel(
    id: json["id"],
    createdAt: json["expiry"] == null ? null : DateTime.parse(json["expiry"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    patientId: json["patient_id"],
    doctorId: json["client_id"],
    senderId: json["sender_id"],

    status: json["conv_status"],
    readCount: json["read_count"],
    message: json["message"],
    patientRead: json["patient_read"],
    userRead: json["user_read"],
    user:fromCreate ?json["userData"] == null ? null : UserModel.fromJson(json["userData"]):  json["userData"] == null ? null : UserModel.fromJson(json["userData"]),
    me: UserBloc.instance.user,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "patient_id": patientId,
    "doctor_id": doctorId,
    "read_count": readCount,
    "message": message,
    "patient_read": patientRead,
    "user_read": userRead,
    "doctor": user?.toJson(),
    "patient": me?.toJson(),
  };
}


