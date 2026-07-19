import 'package:equatable/equatable.dart';
import '../../../../core/enums/payment_status.dart';

class Payment extends Equatable {
  final int? id;
  final int studentId;
  final double amount;

  /// Örn: "Ocak 2026"
  final String period;
  final DateTime dueDate;
  final DateTime? paidDate;
  final PaymentStatus status;

  /// Bu ödeme için şimdiye kadar tahsil edilen toplam tutar (kısmi ödemeler
  /// dahil, kümülatif). 0 ile [amount] arasında bir değer.
  final double paidAmount;

  const Payment({
    this.id,
    required this.studentId,
    required this.amount,
    required this.period,
    required this.dueDate,
    this.paidDate,
    required this.status,
    this.paidAmount = 0,
  });

  /// Henüz tahsil edilmemiş kalan tutar.
  double get remainingAmount => (amount - paidAmount).clamp(0, amount);

  bool get isFullyPaid => paidAmount >= amount;

  Payment copyWith({
    int? id,
    int? studentId,
    double? amount,
    String? period,
    DateTime? dueDate,
    DateTime? paidDate,
    PaymentStatus? status,
    double? paidAmount,
  }) {
    return Payment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
      paidAmount: paidAmount ?? this.paidAmount,
    );
  }

  @override
  List<Object?> get props =>
      [id, studentId, amount, period, dueDate, paidDate, status, paidAmount];
}
