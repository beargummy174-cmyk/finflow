import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/budget_model.dart';
import '../../transactions/providers/transaction_provider.dart';

enum BudgetStatus { safe, warning, overbudget }

class BudgetStatusItem {
  final BudgetModel budget;
  final double spent;
  final double percentage;
  final BudgetStatus status;

  BudgetStatusItem({
    required this.budget,
    required this.spent,
    required this.percentage,
    required this.status,
  });
}

class BudgetNotifier extends StateNotifier<List<BudgetModel>> {
  BudgetNotifier() : super(_initialBudgets);

  static final List<BudgetModel> _initialBudgets = [
    BudgetModel(
      id: 'b_food',
      categoryId: 'cat_food',
      categoryName: 'Makan & Minum',
      limitAmount: 2000000.0,
      month: DateTime.now().month,
      year: DateTime.now().year,
    ),
    BudgetModel(
      id: 'b_transport',
      categoryId: 'cat_transport',
      categoryName: 'Transportasi',
      limitAmount: 600000.0,
      month: DateTime.now().month,
      year: DateTime.now().year,
    ),
    BudgetModel(
      id: 'b_shopping',
      categoryId: 'cat_shopping',
      categoryName: 'Belanja',
      limitAmount: 1000000.0,
      month: DateTime.now().month,
      year: DateTime.now().year,
    ),
    BudgetModel(
      id: 'b_bills',
      categoryId: 'cat_bills',
      categoryName: 'Tagihan & Utilitas',
      limitAmount: 800000.0,
      month: DateTime.now().month,
      year: DateTime.now().year,
    ),
  ];

  void setBudget({
    required String categoryId,
    required String categoryName,
    required double limitAmount,
    required int month,
    required int year,
  }) {
    final existingIndex = state.indexWhere(
      (b) => b.categoryId == categoryId && b.month == month && b.year == year,
    );

    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = updated[existingIndex].copyWith(limitAmount: limitAmount);
      state = updated;
    } else {
      final newBudget = BudgetModel(
        id: const Uuid().v4(),
        categoryId: categoryId,
        categoryName: categoryName,
        limitAmount: limitAmount,
        month: month,
        year: year,
      );
      state = [...state, newBudget];
    }
  }

  void removeBudget(String id) {
    state = state.where((b) => b.id != id).toList();
  }
}

final budgetProvider =
    StateNotifierProvider<BudgetNotifier, List<BudgetModel>>((ref) {
  return BudgetNotifier();
});

// Computed provider to combine Budgets with actual Transaction spending
final budgetStatusListProvider = Provider<List<BudgetStatusItem>>((ref) {
  final budgets = ref.watch(budgetProvider);
  final txState = ref.watch(transactionProvider);
  final currentMonth = DateTime.now().month;
  final currentYear = DateTime.now().year;

  return budgets.map((b) {
    final spent = txState.getExpenseForCategory(b.categoryId, currentMonth, currentYear);
    final percentage = b.limitAmount > 0 ? (spent / b.limitAmount) : 0.0;

    BudgetStatus status;
    if (percentage >= 1.0) {
      status = BudgetStatus.overbudget;
    } else if (percentage >= 0.8) {
      status = BudgetStatus.warning;
    } else {
      status = BudgetStatus.safe;
    }

    return BudgetStatusItem(
      budget: b,
      spent: spent,
      percentage: percentage,
      status: status,
    );
  }).toList();
});
