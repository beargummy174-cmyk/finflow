import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../auth/providers/auth_provider.dart';
import '../../budgets/providers/budget_provider.dart';
import '../../transactions/models/category_model.dart';
import '../../transactions/models/transaction_model.dart';
import '../../transactions/providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/budget_preview_card.dart';

class DashboardScreen extends ConsumerWidget {
  final Function(int) onNavigateTab;

  const DashboardScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final txState = ref.watch(transactionProvider);
    final budgetStatusList = ref.watch(budgetStatusListProvider);

    final recentTransactions = txState.transactions.take(5).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Halo, Selamat Datang! 👋',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authState.user?.displayName ?? 'Pengguna FinFlow',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLightDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 1.5),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Balance Card
              BalanceCard(
                netBalance: txState.netBalance,
                totalIncome: txState.totalIncome,
                totalExpense: txState.totalExpense,
              ),
              const SizedBox(height: 20),

              // Budget Preview
              BudgetPreviewCard(
                items: budgetStatusList,
                onSeeAll: () => onNavigateTab(2), // Tab Anggaran
              ),
              const SizedBox(height: 24),

              // Recent Transactions Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Transaksi Terkini',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () => onNavigateTab(1), // Tab Riwayat
                    child: const Text(
                      'Semua',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recent Transactions List
              if (recentTransactions.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  alignment: Alignment.center,
                  child: const Text(
                    'Belum ada transaksi. Tekan tombol + untuk mulai!',
                    style: TextStyle(color: AppColors.textMuted),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final tx = recentTransactions[index];
                    final isExpense = tx.type == TransactionType.expense;

                    // Match category icon
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

                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
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
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.categoryName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${DateFormat('dd MMM').format(tx.date)} • ${tx.walletName}',
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
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isExpense
                                  ? AppColors.expense
                                  : AppColors.income,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
