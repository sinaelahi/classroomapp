import 'package:equatable/equatable.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/payment_summary.dart';

enum PaymentStatusFlag { initial, loading, success, failure }

class PaymentState extends Equatable {
  final PaymentStatusFlag status;
  final List<Payment> payments;
  final PaymentSummary summary;
  final String? errorMessage;

  const PaymentState({
    this.status = PaymentStatusFlag.initial,
    this.payments = const [],
    this.summary = const PaymentSummary.empty(),
    this.errorMessage,
  });

  PaymentState copyWith({
    PaymentStatusFlag? status,
    List<Payment>? payments,
    PaymentSummary? summary,
    String? errorMessage,
  }) {
    return PaymentState(
      status: status ?? this.status,
      payments: payments ?? this.payments,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, payments, summary, errorMessage];
}
