class PlansModel {
  String? status;
  String? message;
  List<PlanData>? data;

  PlansModel({this.status, this.message, this.data});

  PlansModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PlanData>[];
      json['data'].forEach((v) {
        data!.add(new PlanData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PlanData {
  int? id;
  String? name;
  int? numberOfChats;
  int? numberOfLikes;
  int? length;
  int? amount;
  int? worldWowAvailable;
  List<Features>? features;

  PlanData(
      {this.id,
      this.name,
      this.numberOfChats,
      this.numberOfLikes,
      this.length,
      this.amount,
      this.worldWowAvailable,
      this.features});

  PlanData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    numberOfChats = json['number_of_chats'];
    numberOfLikes = json['number_of_likes'];
    length = json['length'];
    amount = json['amount'];
    worldWowAvailable = json['world_wow_available'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['number_of_chats'] = this.numberOfChats;
    data['number_of_likes'] = this.numberOfLikes;
    data['length'] = this.length;
    data['amount'] = this.amount;
    data['world_wow_available'] = this.worldWowAvailable;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  int? id;
  String? name;
  String? description;

  Features({this.id, this.name, this.description});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
