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

  const Payment({
    this.id,
    required this.studentId,
    required this.amount,
    required this.period,
    required this.dueDate,
    this.paidDate,
    required this.status,
  });

  Payment copyWith({
    int? id,
    int? studentId,
    double? amount,
    String? period,
    DateTime? dueDate,
    DateTime? paidDate,
    PaymentStatus? status,
  }) {
    return Payment(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      amount: amount ?? this.amount,
      period: period ?? this.period,
      dueDate: dueDate ?? this.dueDate,
      paidDate: paidDate ?? this.paidDate,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, studentId, amount, period, dueDate, paidDate, status];
}
