import 'package:equatable/equatable.dart';
import '../../domain/entities/payment.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class LoadPayments extends PaymentEvent {
  const LoadPayments();
}

class AddPaymentRequested extends PaymentEvent {
  final int studentId;
  final double amount;
  final String period;
  final DateTime dueDate;

  const AddPaymentRequested({
    required this.studentId,
    required this.amount,
    required this.period,
    required this.dueDate,
  });

  @override
  List<Object?> get props => [studentId, amount, period, dueDate];
}

class RecordPaymentRequested extends PaymentEvent {
  final Payment payment;
  final double amountReceived;
  const RecordPaymentRequested({
    required this.payment,
    required this.amountReceived,
  });

  @override
  List<Object?> get props => [payment, amountReceived];
}

class UpdatePaymentRequested extends PaymentEvent {
  final Payment payment;
  const UpdatePaymentRequested(this.payment);

  @override
  List<Object?> get props => [payment];
}

class DeletePaymentRequested extends PaymentEvent {
  final int id;
  const DeletePaymentRequested(this.id);

  @override
  List<Object?> get props => [id];
}
