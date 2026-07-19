import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _CashView extends StatelessWidget {
  const _CashView();

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
            const SizedBox(height: 24),
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

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _SummaryCard(
                            label: 'Toplam Gelir',
                            amount: state.summary.totalIncome,
                            color: AppColors.mint,
                          ),
                          const SizedBox(width: 16),
                          _SummaryCard(
                            label: 'Toplam Gider',
                            amount: state.summary.totalExpense,
                            color: AppColors.coral,
                          ),
                          const SizedBox(width: 16),
                          _SummaryCard(
                            label: 'Bakiye',
                            amount: state.summary.balance,
                            color: state.summary.balance >= 0
                                ? AppColors.mint
                                : AppColors.coral,
                            emphasized: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: state.transactions.isEmpty
                            ?  Center(
                                child: Text(
                                  'Henüz bir kayıt yok',
                                  style: AppTextStyles.body,
                                ),
                              )
                            : Card(
                                child: ListView.separated(
                                  itemCount: state.transactions.length,
                                  separatorBuilder: (_, __) =>
                                      const Divider(height: 1, color: AppColors.border),
                                  itemBuilder: (context, index) {
                                    final tx = state.transactions[index];
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
