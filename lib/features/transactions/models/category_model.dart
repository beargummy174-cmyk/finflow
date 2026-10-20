import 'package:flutter/material.dart';

enum TransactionType { expense, income }

class CategoryModel {
  final String id;
  final String name;
  final TransactionType type;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.type,
    required this.icon,
    required this.color,
  });

  static List<CategoryModel> defaultCategories = [
    // Expenses
    const CategoryModel(
      id: 'cat_food',
      name: 'Makan & Minum',
      type: TransactionType.expense,
      icon: Icons.restaurant,
      color: Color(0xFFF97316),
    ),
    const CategoryModel(
      id: 'cat_transport',
      name: 'Transportasi',
      type: TransactionType.expense,
      icon: Icons.directions_car,
      color: Color(0xFF0EA5E9),
    ),
    const CategoryModel(
      id: 'cat_shopping',
      name: 'Belanja',
      type: TransactionType.expense,
      icon: Icons.shopping_bag,
      color: Color(0xFFEC4899),
    ),
    const CategoryModel(
      id: 'cat_bills',
      name: 'Tagihan & Utilitas',
      type: TransactionType.expense,
      icon: Icons.receipt_long,
      color: Color(0xFF8B5CF6),
    ),
    const CategoryModel(
      id: 'cat_entertainment',
      name: 'Hiburan',
      type: TransactionType.expense,
      icon: Icons.sports_esports,
      color: Color(0xFF14B8A6),
    ),
    const CategoryModel(
      id: 'cat_health',
      name: 'Kesehatan',
      type: TransactionType.expense,
      icon: Icons.medical_services,
      color: Color(0xFFEF4444),
    ),

    // Incomes
    const CategoryModel(
      id: 'cat_salary',
      name: 'Gaji Bulanan',
      type: TransactionType.income,
      icon: Icons.account_balance_wallet,
      color: Color(0xFF10B981),
    ),
    const CategoryModel(
      id: 'cat_freelance',
      name: 'Proyek / Freelance',
      type: TransactionType.income,
      icon: Icons.laptop_mac,
      color: Color(0xFF6366F1),
    ),
    const CategoryModel(
      id: 'cat_investment',
      name: 'Investasi & Bunga',
      type: TransactionType.income,
      icon: Icons.trending_up,
      color: Color(0xFFF59E0B),
    ),
  ];
}
