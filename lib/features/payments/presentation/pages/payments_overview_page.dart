import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/layouts/desktop_scaffold.dart';
import '../../../../shared/widgets/status_badge.dart';
import '../../../students/domain/entities/student.dart';
import '../../../students/presentation/bloc/student_bloc.dart';
import '../../../students/presentation/bloc/student_event.dart';
import '../../../students/presentation/bloc/student_state.dart';
import '../../domain/entities/payment.dart';
import '../bloc/payment_bloc.dart';
import '../bloc/payment_event.dart';
import '../bloc/payment_state.dart';
import '../widgets/payment_form_dialog.dart';

class PaymentsOverviewPage extends StatelessWidget {
  const PaymentsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PaymentBloc>()..add(const LoadPayments())),
        BlocProvider(create: (_) => sl<StudentBloc>()..add(const LoadStudents())),
      ],
      child: const _PaymentsOverviewView(),
    );
  }
}

class _PaymentsOverviewView extends StatelessWidget {
  const _PaymentsOverviewView();

  String _studentName(List<Student> students, int studentId) {
    final match = students.where((s) => s.id == studentId);
    return match.isEmpty ? 'Bilinmeyen Öğrenci' : match.first.fullName;
  }

  void _openPaymentForm(
    BuildContext context,
    List<Student> students, {
    Payment? payment,
  }) {
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Önce Öğrenciler sayfasından öğrenci eklemelisin'),
        ),
      );
      return;
    }
    final bloc = context.read<PaymentBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => PaymentFormDialog(
        initialPayment: payment,
        students: students,
        onSubmit: (studentId, amount, period, dueDate) {
          if (payment == null) {
            bloc.add(
              AddPaymentRequested(
                studentId: studentId,
                amount: amount,
                period: period,
                dueDate: dueDate,
              ),
            );
          } else {
            bloc.add(
              UpdatePaymentRequested(
                payment.copyWith(
                  studentId: studentId,
                  amount: amount,
                  period: period,
                  dueDate: dueDate,
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
      currentRoute: '/payments',
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.contentPadding),
        child: BlocBuilder<StudentBloc, StudentState>(
          builder: (context, studentState) {
            final students = studentState.students;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Ödemeler', style: AppTextStyles.heading1),
                    FilledButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Ödeme Ekle'),
                      onPressed: () => _openPaymentForm(context, students),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                      if (state.status == PaymentStatusFlag.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              _SummaryCard(
                                label: 'Ödenen',
                                amount: state.summary.totalPaidAmount,
                              ),
                              const SizedBox(width: 16),
                              _SummaryCard(
                                label: 'Ödenmeyen',
                                amount: state.summary.totalUnpaidAmount,
                              ),
                              const SizedBox(width: 16),
                              _SummaryCard(
                                label: 'Ödenecek',
                                amount: state.summary.totalUpcomingAmount,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: state.payments.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Henüz ödeme kaydı yok',
                                      style: AppTextStyles.body,
                                    ),
                                  )
                                : Card(
                                    child: ListView.separated(
                                      itemCount: state.payments.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final payment = state.payments[index];
                                        return ListTile(
                                          title: Text(
                                            _studentName(students, payment.studentId),
                                          ),
                                          subtitle: Text(
                                            '${payment.period} · Vade: '
                                            '${DateFormatter.format(payment.dueDate)}',
                                          ),
                                          onTap: () => _openPaymentForm(
                                            context,
                                            students,
                                            payment: payment,
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(CurrencyFormatter.format(payment.amount)),
                                              const SizedBox(width: 12),
                                              StatusBadge(status: payment.status),
                                              if (payment.status != PaymentStatus.paid)
                                                IconButton(
                                                  icon: const Icon(Icons.check_circle_outline),
                                                  tooltip: 'Ödendi olarak işaretle',
                                                  onPressed: () {
                                                    context.read<PaymentBloc>().add(
                                                          MarkPaymentAsPaidRequested(payment),
                                                        );
                                                  },
                                                ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline),
                                                onPressed: () {
                                                  context.read<PaymentBloc>().add(
                                                        DeletePaymentRequested(payment.id!),
                                                      );
                                                },
                                              ),
                                            ],
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
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double amount;
  const _SummaryCard({required this.label, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 8),
              Text(
                CurrencyFormatter.format(amount),
                style: AppTextStyles.heading2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
