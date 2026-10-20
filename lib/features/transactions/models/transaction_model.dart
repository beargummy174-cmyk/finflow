import 'category_model.dart';

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String categoryId;
  final String categoryName;
  final String walletName;
  final String note;
  final DateTime date;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.walletName,
    required this.note,
    required this.date,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      type: map['type'] == 'income' ? TransactionType.income : TransactionType.expense,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? 'Lain-lain',
      walletName: map['walletName'] ?? 'Dompet Utama',
      note: map['note'] ?? '',
      date: map['date'] != null
          ? DateTime.tryParse(map['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type == TransactionType.income ? 'income' : 'expense',
      'amount': amount,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'walletName': walletName,
      'note': note,
      'date': date.toIso8601String(),
    };
  }

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? categoryId,
    String? categoryName,
    String? walletName,
    String? note,
    DateTime? date,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      walletName: walletName ?? this.walletName,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }
}
