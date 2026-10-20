import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../transactions/models/category_model.dart';
import '../models/budget_model.dart';
import '../providers/budget_provider.dart';

class AddBudgetDialog extends ConsumerStatefulWidget {
  final BudgetModel? existingBudget;

  const AddBudgetDialog({super.key, this.existingBudget});

  @override
  ConsumerState<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends ConsumerState<AddBudgetDialog> {
  final TextEditingController _amountController = TextEditingController();
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    super.initState();
    final expenseCategories = CategoryModel.defaultCategories
        .where((c) => c.type == TransactionType.expense)
        .toList();

    if (widget.existingBudget != null) {
      _amountController.text =
          widget.existingBudget!.limitAmount.toInt().toString();
      _selectedCategory = expenseCategories.firstWhere(
        (c) => c.id == widget.existingBudget!.categoryId,
        orElse: () => expenseCategories.first,
      );
    } else {
      _selectedCategory = expenseCategories.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _saveBudget() {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limitAmount = double.tryParse(amountText);

    if (limitAmount == null || limitAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan batas anggaran yang valid'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    if (_selectedCategory == null) return;

    ref.read(budgetProvider.notifier).setBudget(
          categoryId: _selectedCategory!.id,
          categoryName: _selectedCategory!.name,
          limitAmount: limitAmount,
          month: DateTime.now().month,
          year: DateTime.now().year,
        );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final expenseCategories = CategoryModel.defaultCategories
        .where((c) => c.type == TransactionType.expense)
        .toList();

    return Dialog(
      backgroundColor: AppColors.surfaceDark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.existingBudget != null
                      ? 'Edit Batas Anggaran'
                      : 'Tetapkan Anggaran Baru',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Kategori Pengeluaran',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory?.id,
              dropdownColor: AppColors.surfaceDark,
              decoration: const InputDecoration(),
              items: expenseCategories.map((c) {
                return DropdownMenuItem(
                  value: c.id,
                  child: Row(
                    children: [
                      Icon(c.icon, color: c.color, size: 18),
                      const SizedBox(width: 10),
                      Text(c.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedCategory = expenseCategories.firstWhere(
                      (c) => c.id == val,
                    );
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Batas Pagu Bulanan (Rp)',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                prefixText: 'Rp ',
                prefixStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                hintText: '1.000.000',
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveBudget,
                child: const Text('Simpan Anggaran'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
