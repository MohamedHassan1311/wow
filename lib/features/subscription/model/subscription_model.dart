import '../../../data/config/mapper.dart';

class SubscriptionModel extends SingleMapper {
  final String id;
  final String name;
  final String description;
  final double price;
  final bool isActive;

  final DateTime endDate;

  SubscriptionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,

    required this.isActive,

    required this.endDate,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] ??"",
      price: (json['amount']).toDouble(),
      isActive: json['status'] == 1,
      endDate: DateTime.parse(json['expiring_on'] ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'is_active': isActive,
      'end_date': endDate.toIso8601String(),
    };
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return SubscriptionModel.fromJson(json);
  }
} 