import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../providers/transaction_provider.dart';

class TransactionHistoryScreen extends ConsumerStatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  ConsumerState<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState
    extends ConsumerState<TransactionHistoryScreen> {
  String _filterType = 'all'; // 'all', 'expense', 'income'

  @override
  Widget build(BuildContext context) {
    final txState = ref.watch(transactionProvider);

    final filteredTransactions = txState.transactions.where((tx) {
      if (_filterType == 'expense') return tx.type == TransactionType.expense;
      if (_filterType == 'income') return tx.type == TransactionType.income;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Transaksi'),
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                _buildFilterChip('Semua', 'all'),
                const SizedBox(width: 8),
                _buildFilterChip('Pengeluaran', 'expense'),
                const SizedBox(width: 8),
                _buildFilterChip('Pemasukan', 'income'),
              ],
            ),
          ),

          // Transaction Count / Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredTransactions.length} Transaksi Ditemukan',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: filteredTransactions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.receipt_long_outlined,
                            size: 48, color: AppColors.textMuted),
                        SizedBox(height: 12),
                        Text(
                          'Tidak ada transaksi pada filter ini',
                          style: TextStyle(color: AppColors.textMuted),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    itemCount: filteredTransactions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final tx = filteredTransactions[index];
                      final isExpense = tx.type == TransactionType.expense;

                      final category = CategoryModel.defaultCategories.firstWhere(
                        (c) => c.id == tx.categoryId,
                        orElse: () => CategoryModel(
                          id: 'default',
                          name: tx.categoryName,
                          type: tx.type,
                          icon: Icons.category,
                          color: AppColors.secondary,
                        ),
                      );

                      return Dismissible(
                        key: Key(tx.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: AppColors.expense.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete,
                              color: AppColors.expense),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Hapus Transaksi?'),
                              content: Text(
                                  'Apakah kamu yakin ingin menghapus catatan ${tx.categoryName}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx, false),
                                  child: const Text('Batal'),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.expense),
                                  onPressed: () => Navigator.pop(ctx, true),
                                  child: const Text('Hapus'),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) {
                          ref
                              .read(transactionProvider.notifier)
                              .deleteTransaction(tx.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Transaksi berhasil dihapus'),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.borderDark),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: category.color.withOpacity(0.18),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  category.icon,
                                  color: category.color,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tx.categoryName,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (tx.note.isNotEmpty) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        tx.note,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                    Text(
                                      '${DateFormat('dd MMM yyyy').format(tx.date)} • ${tx.walletName}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${isExpense ? '-' : '+'} ${CurrencyFormatter.format(tx.amount)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isExpense
                                      ? AppColors.expense
                                      : AppColors.income,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filterType == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterType = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
