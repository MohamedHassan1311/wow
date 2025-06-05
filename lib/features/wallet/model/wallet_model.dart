import 'package:wow/features/transactions/model/transactions_model.dart';

import '../../../data/config/mapper.dart';

class WalletModel extends SingleMapper {
  final String id;
  final double balance;
  final String currency;
  final DateTime lastTransactionDate;
  final String status;
  final String type;
  final String description;
  final List<TransactionModel> transactions;
  WalletModel({
    required this.id,
    required this.balance,
    required this.currency,
    required this.lastTransactionDate,
    required this.status,
    required this.type,
    required this.description,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      balance: (json['balance'] as num).toDouble(),
      currency: json['currency'] as String,
      lastTransactionDate: DateTime.parse(json['last_transaction_date'] as String),
      status: json['status'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      transactions: (json['transactions'] as List)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'balance': balance,
      'currency': currency,
      'last_transaction_date': lastTransactionDate.toIso8601String(),
      'status': status,
      'type': type,
      'description': description,
      'transactions': transactions.map((e) => e.toJson()).toList(),
    };
  }

  @override
  Mapper fromJson(Map<String, dynamic> json) {
    return WalletModel.fromJson(json);
  }
} 