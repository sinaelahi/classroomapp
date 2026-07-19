import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/layouts/desktop_scaffold.dart';
import '../../../../shared/widgets/animated_count.dart';
import '../../../../shared/widgets/fade_slide_in.dart';
import '../../../../shared/widgets/hover_lift.dart';
import '../../domain/entities/cash_transaction.dart';
import '../bloc/cash_bloc.dart';
import '../bloc/cash_event.dart';
import '../bloc/cash_state.dart';
import '../widgets/cash_transaction_form_dialog.dart';

class CashPage extends StatelessWidget {
  const CashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CashBloc>()..add(const LoadCashTransactions()),
      child: const _CashView(),
    );
  }
}

/// Bir ayı (yıl + ay) benzersiz şekilde temsil eder — filtre anahtarı olarak
/// kullanılıyor, gün bilgisiyle uğraşmaya gerek kalmıyor.
class _MonthKey {
  final int year;
  final int month;
  const _MonthKey(this.year, this.month);

  factory _MonthKey.fromDate(DateTime date) => _MonthKey(date.year, date.month);

  String get label =>
      DateFormat('MMMM yyyy', 'tr_TR').format(DateTime(year, month));

  @override
  bool operator ==(Object other) =>
      other is _MonthKey && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}

class _CashView extends StatefulWidget {
  const _CashView();

  @override
  State<_CashView> createState() => _CashViewState();
}

class _CashViewState extends State<_CashView> {
  _MonthKey? _selectedMonth;

  void _openForm(BuildContext context, {CashTransaction? transaction}) {
    final bloc = context.read<CashBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => CashTransactionFormDialog(
        initialTransaction: transaction,
        onSubmit: (title, amount, type, date) {
          if (transaction == null) {
            bloc.add(
              AddCashTransactionRequested(
                title: title,
                amount: amount,
                type: type,
                date: date,
              ),
            );
          } else {
            bloc.add(
              UpdateCashTransactionRequested(
                transaction.copyWith(
                  title: title,
                  amount: amount,
                  type: type,
                  date: date,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DesktopScaffold(
      currentRoute: '/cash',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.contentPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Kasa Sistemi', style: AppTextStyles.heading1),
                FilledButton.icon(
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Gelir / Gider Ekle'),
                  onPressed: () => _openForm(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<CashBloc, CashState>(
                builder: (context, state) {
                  if (state.status == CashStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.status == CashStatus.failure) {
                    return Center(
                      child: Text(state.errorMessage ?? 'Bir hata oluştu'),
                    );
                  }

                  // Kayıtlarda geçen ayları benzersiz şekilde çıkar, en
                  // yeniden en eskiye sırala.
                  final months = <_MonthKey>{
                    for (final tx in state.transactions) _MonthKey.fromDate(tx.date),
                  }.toList()
                    ..sort((a, b) {
                      final da = DateTime(a.year, a.month);
                      final db = DateTime(b.year, b.month);
                      return db.compareTo(da);
                    });

                  final filteredTransactions = _selectedMonth == null
                      ? state.transactions
                      : state.transactions
                          .where((tx) =>
                              _MonthKey.fromDate(tx.date) == _selectedMonth)
                          .toList();

                  double income = 0;
                  double expense = 0;
                  for (final tx in filteredTransactions) {
                    if (tx.type == CashType.income) {
                      income += tx.amount;
                    } else {
                      expense += tx.amount;
                    }
                  }
                  final balance = income - expense;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (months.isNotEmpty) ...[
                        _MonthFilterBar(
                          months: months,
                          selected: _selectedMonth,
                          onChanged: (month) =>
                              setState(() => _selectedMonth = month),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          _SummaryCard(
                            label: 'Toplam Gelir',
                            amount: income,
                            color: AppColors.mint,
                          ),
                          const SizedBox(width: 16),
                          _SummaryCard(
                            label: 'Toplam Gider',
                            amount: expense,
                            color: AppColors.coral,
                          ),
                          const SizedBox(width: 16),
                          _SummaryCard(
                            label: 'Bakiye',
                            amount: balance,
                            color: balance >= 0 ? AppColors.mint : AppColors.coral,
                            emphasized: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: filteredTransactions.isEmpty
                            ? Center(
                                child: Text(
                                  state.transactions.isEmpty
                                      ? 'Henüz bir kayıt yok'
                                      : 'Bu ayda kayıt yok',
                                  style: AppTextStyles.body,
                                ),
                              )
                            : Card(
                                child: ListView.separated(
                                  itemCount: filteredTransactions.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1, color: AppColors.border),
                                  itemBuilder: (context, index) {
                                    final tx = filteredTransactions[index];
                                    final isIncome = tx.type == CashType.income;
                                    final color =
                                        isIncome ? AppColors.mint : AppColors.coral;
                                    return FadeSlideIn(
                                      index: index,
                                      child: ListTile(
                                        leading: Container(
                                          width: 36,
                                          height: 36,
                                          decoration: BoxDecoration(
                                            color: color.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            isIncome
                                                ? Icons.arrow_upward_rounded
                                                : Icons.arrow_downward_rounded,
                                            color: color,
                                            size: 18,
                                          ),
                                        ),
                                        title: Text(tx.title, style: AppTextStyles.bodyMedium),
                                        subtitle: Text(
                                          DateFormatter.format(tx.date),
                                          style: AppTextStyles.caption,
                                        ),
                                        onTap: () =>
                                            _openForm(context, transaction: tx),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${isIncome ? '+' : '-'}'
                                              '${CurrencyFormatter.format(tx.amount)}',
                                              style: AppTextStyles.figureSmall.copyWith(
                                                color: color,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete_outline),
                                              color: AppColors.textSecondary,
                                              onPressed: () {
                                                context.read<CashBloc>().add(
                                                      DeleteCashTransactionRequested(
                                                        tx.id!,
                                                      ),
                                                    );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthFilterBar extends StatelessWidget {
  final List<_MonthKey> months;
  final _MonthKey? selected;
  final ValueChanged<_MonthKey?> onChanged;

  const _MonthFilterBar({
    required this.months,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _FilterChip(
            label: 'Tüm Aylar',
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: 8),
          for (final month in months) ...[
            _FilterChip(
              label: month.label,
              selected: selected == month,
              onTap: () => onChanged(month),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.indigoSoft,
      labelStyle: TextStyle(
        color: selected ? AppColors.indigo : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
      ),
      side: BorderSide(color: selected ? AppColors.indigo : AppColors.border),
      backgroundColor: AppColors.surface,
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  final Color color;
  final bool emphasized;

  const _SummaryCard({
    required this.label,
    required this.amount,
    required this.color,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: HoverLift(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 8),
                    Text(label, style: AppTextStyles.caption),
                  ],
                ),
                const SizedBox(height: 10),
                AnimatedCount(
                  value: amount,
                  formatter: CurrencyFormatter.format,
                  style: AppTextStyles.figure.copyWith(
                    color: emphasized ? color : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
