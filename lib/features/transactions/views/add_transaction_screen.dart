import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';
import '../providers/transaction_provider.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  TransactionType _selectedType = TransactionType.expense;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  CategoryModel? _selectedCategory;
  String _selectedWallet = 'Bank BCA';
  DateTime _selectedDate = DateTime.now();

  final List<String> _wallets = [
    'Bank BCA',
    'Bank Mandiri',
    'GoPay',
    'OVO',
    'Tunai / Cash',
  ];

  @override
  void initState() {
    super.initState();
    _setDefaultCategory();
  }

  void _setDefaultCategory() {
    final available = CategoryModel.defaultCategories
        .where((c) => c.type == _selectedType)
        .toList();
    if (available.isNotEmpty) {
      _selectedCategory = available.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    final amountText = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal transaksi yang valid'),
          backgroundColor: AppColors.expense,
        ),
      );
      return;
    }

    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori transaksi terlebih dahulu'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    ref.read(transactionProvider.notifier).addTransaction(
          type: _selectedType,
          amount: amount,
          categoryId: _selectedCategory!.id,
          categoryName: _selectedCategory!.name,
          walletName: _selectedWallet,
          note: _noteController.text.trim(),
          date: _selectedDate,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Transaksi ${_selectedCategory!.name} berhasil disimpan!',
        ),
        backgroundColor: AppColors.primary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final availableCategories = CategoryModel.defaultCategories
        .where((c) => c.type == _selectedType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catat Transaksi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Switcher: Pengeluaran / Pemasukan
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = TransactionType.expense;
                          _setDefaultCategory();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == TransactionType.expense
                              ? AppColors.expense.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: _selectedType == TransactionType.expense
                              ? Border.all(color: AppColors.expense)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Pengeluaran',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedType == TransactionType.expense
                                ? AppColors.expense
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedType = TransactionType.income;
                          _setDefaultCategory();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedType == TransactionType.income
                              ? AppColors.income.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: _selectedType == TransactionType.income
                              ? Border.all(color: AppColors.income)
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Pemasukan',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selectedType == TransactionType.income
                                ? AppColors.income
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Nominal Input
            const Text(
              'Nominal (Rp)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                prefixStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                hintText: '0',
                hintStyle: TextStyle(
                  color: AppColors.textMuted.withOpacity(0.5),
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Kategori Selection
            const Text(
              'Pilih Kategori',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.15,
              ),
              itemCount: availableCategories.length,
              itemBuilder: (context, index) {
                final cat = availableCategories[index];
                final isSelected = _selectedCategory?.id == cat.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected
                          ? cat.color.withOpacity(0.25)
                          : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? cat.color : AppColors.borderDark,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          cat.icon,
                          color: isSelected ? cat.color : AppColors.textSecondary,
                          size: 26,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          cat.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Dompet / Akun
            const Text(
              'Dompet / Rekening',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedWallet,
              decoration: const InputDecoration(),
              dropdownColor: AppColors.surfaceDark,
              items: _wallets.map((wallet) {
                return DropdownMenuItem(
                  value: wallet,
                  child: Text(wallet),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedWallet = val;
                  });
                }
              },
            ),
            const SizedBox(height: 20),

            // Tanggal Transaksi
            const Text(
              'Tanggal Transaksi',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                          .format(_selectedDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Icon(Icons.calendar_today,
                        size: 18, color: AppColors.primary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Catatan Tambahan
            const Text(
              'Catatan (Opsional)',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Kopi bareng teman atau makan siang',
              ),
            ),
            const SizedBox(height: 32),

            // Simpan Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _saveTransaction,
                child: const Text(
                  'Simpan Transaksi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
