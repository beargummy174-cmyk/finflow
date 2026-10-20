import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

class TransactionState {
  final List<TransactionModel> transactions;
  final bool isLoading;

  const TransactionState({
    required this.transactions,
    this.isLoading = false,
  });

  double get totalIncome => transactions
      .where((t) => t.type == TransactionType.income)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpense => transactions
      .where((t) => t.type == TransactionType.expense)
      .fold(0.0, (sum, t) => sum + t.amount);

  double get netBalance => totalIncome - totalExpense;

  double getExpenseForCategory(String categoryId, int month, int year) {
    return transactions
        .where((t) =>
            t.type == TransactionType.expense &&
            t.categoryId == categoryId &&
            t.date.month == month &&
            t.date.year == year)
        .fold(0.0, (sum, t) => sum + t.amount);
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  TransactionNotifier()
      : super(TransactionState(transactions: _initialSampleTransactions));

  static final List<TransactionModel> _initialSampleTransactions = [
    TransactionModel(
      id: 'tx_1',
      type: TransactionType.income,
      amount: 8500000.0,
      categoryId: 'cat_salary',
      categoryName: 'Gaji Bulanan',
      walletName: 'Bank BCA',
      note: 'Gaji Pokok Oktober',
      date: DateTime.now().subtract(const Duration(days: 4)),
    ),
    TransactionModel(
      id: 'tx_2',
      type: TransactionType.expense,
      amount: 450000.0,
      categoryId: 'cat_food',
      categoryName: 'Makan & Minum',
      walletName: 'GoPay',
      note: 'Belanja makan mingguan',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    TransactionModel(
      id: 'tx_3',
      type: TransactionType.expense,
      amount: 150000.0,
      categoryId: 'cat_transport',
      categoryName: 'Transportasi',
      walletName: 'OVO',
      note: 'Bensin & Tol',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    TransactionModel(
      id: 'tx_4',
      type: TransactionType.expense,
      amount: 250000.0,
      categoryId: 'cat_bills',
      categoryName: 'Tagihan & Utilitas',
      walletName: 'Bank Mandiri',
      note: 'Tagihan Internet Wi-Fi',
      date: DateTime.now(),
    ),
  ];

  void addTransaction({
    required TransactionType type,
    required double amount,
    required String categoryId,
    required String categoryName,
    required String walletName,
    required String note,
    required DateTime date,
  }) {
    final newTx = TransactionModel(
      id: const Uuid().v4(),
      type: type,
      amount: amount,
      categoryId: categoryId,
      categoryName: categoryName,
      walletName: walletName,
      note: note,
      date: date,
    );

    state = TransactionState(
      transactions: [newTx, ...state.transactions],
    );
  }

  void deleteTransaction(String id) {
    state = TransactionState(
      transactions: state.transactions.where((t) => t.id != id).toList(),
    );
  }
}

final transactionProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>((ref) {
  return TransactionNotifier();
});
