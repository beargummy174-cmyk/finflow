class BudgetModel {
  final String id;
  final String categoryId;
  final String categoryName;
  final double limitAmount;
  final int month;
  final int year;

  const BudgetModel({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.limitAmount,
    required this.month,
    required this.year,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map, String id) {
    return BudgetModel(
      id: id,
      categoryId: map['categoryId'] ?? '',
      categoryName: map['categoryName'] ?? '',
      limitAmount: (map['limitAmount'] as num?)?.toDouble() ?? 0.0,
      month: map['month'] ?? DateTime.now().month,
      year: map['year'] ?? DateTime.now().year,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'limitAmount': limitAmount,
      'month': month,
      'year': year,
    };
  }

  BudgetModel copyWith({
    String? id,
    String? categoryId,
    String? categoryName,
    double? limitAmount,
    int? month,
    int? year,
  }) {
    return BudgetModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      limitAmount: limitAmount ?? this.limitAmount,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
