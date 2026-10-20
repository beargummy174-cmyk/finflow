import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../transactions/models/category_model.dart';
import '../providers/budget_provider.dart';
import 'add_budget_dialog.dart';

class BudgetScreen extends ConsumerWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetStatusList = ref.watch(budgetStatusListProvider);

    final totalBudget = budgetStatusList.fold(
      0.0,
      (sum, item) => sum + item.budget.limitAmount,
    );
    final totalSpent = budgetStatusList.fold(
      0.0,
      (sum, item) => sum + item.spent,
    );
    final totalRemaining = totalBudget - totalSpent;
    final totalPercentage =
        totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;

    final currentMonthName = DateFormat('MMMM yyyy', 'id_ID').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rencana Anggaran (Budget)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddBudgetDialog(),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bulan: $currentMonthName',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLightDark,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${budgetStatusList.length} Kategori Dibatasi',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Global Budget Summary Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Alokasi Anggaran Bulanan',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    CurrencyFormatter.format(totalBudget),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: totalPercentage,
                      backgroundColor: AppColors.bgDark,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        totalPercentage >= 1.0
                            ? AppColors.expense
                            : totalPercentage >= 0.8
                                ? AppColors.warning
                                : AppColors.primary,
                      ),
                      minHeight: 10,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Sudah Dibelanjakan',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(totalSpent),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.expense,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'Sisa Pagu Aman',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(
                                totalRemaining > 0 ? totalRemaining : 0),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.income,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Rincian Pagu per Kategori',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            if (budgetStatusList.isEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 40),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    const Icon(Icons.pie_chart_outline,
                        size: 48, color: AppColors.textMuted),
                    const SizedBox(height: 12),
                    const Text(
                      'Belum ada batas anggaran yang diatur.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Buat Anggaran Pertama'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddBudgetDialog(),
                        );
                      },
                    ),
                  ],
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: budgetStatusList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = budgetStatusList[index];
                  final isOver = item.status == BudgetStatus.overbudget;
                  final isWarning = item.status == BudgetStatus.warning;

                  Color statusColor = AppColors.income;
                  String badgeText = 'Aman';
                  if (isOver) {
                    statusColor = AppColors.expense;
                    badgeText = 'Overbudget!';
                  } else if (isWarning) {
                    statusColor = AppColors.warning;
                    badgeText = 'Mendekati Limit';
                  }

                  final category = CategoryModel.defaultCategories.firstWhere(
                    (c) => c.id == item.budget.categoryId,
                    orElse: () => CategoryModel(
                      id: 'default',
                      name: item.budget.categoryName,
                      type: TransactionType.expense,
                      icon: Icons.category,
                      color: AppColors.secondary,
                    ),
                  );

                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isOver
                            ? AppColors.expense.withOpacity(0.5)
                            : AppColors.borderDark,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: category.color.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(10),
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
                                    item.budget.categoryName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Pagu: ${CurrencyFormatter.format(item.budget.limitAmount)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                badgeText,
                                style: TextStyle(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AddBudgetDialog(
                                    existingBudget: item.budget,
                                  ),
                                );
                              },
                              child: const Icon(Icons.edit_outlined,
                                  size: 18, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: item.percentage.clamp(0.0, 1.0),
                            backgroundColor: AppColors.bgDark,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(statusColor),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Terpakai: ${CurrencyFormatter.format(item.spent)} (${(item.percentage * 100).toInt()}%)',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                            Text(
                              item.spent <= item.budget.limitAmount
                                  ? 'Sisa: ${CurrencyFormatter.format(item.budget.limitAmount - item.spent)}'
                                  : 'Lebih: ${CurrencyFormatter.format(item.spent - item.budget.limitAmount)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: item.spent <= item.budget.limitAmount
                                    ? AppColors.textSecondary
                                    : AppColors.expense,
                              ),
                            ),
                          ],
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
    );
  }
}
