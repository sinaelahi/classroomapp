import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/enums/payment_status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment.dart';
import '../repositories/payment_repository.dart';

class RecordPaymentParams extends Equatable {
  final Payment payment;

  /// Bu işlemde tahsil edilen tutar (kümülatif paidAmount'a eklenir).
  final double amountReceived;

  const RecordPaymentParams({
    required this.payment,
    required this.amountReceived,
  });

  @override
  List<Object?> get props => [payment, amountReceived];
}

/// Bir ödemeye kısmi ya da tam tahsilat kaydeder. Toplam tahsil edilen
/// tutar, ödemenin toplam tutarına ulaşınca durum otomatik "Ödendi" olur;
/// altındaysa "Kısmi Ödendi" olarak işaretlenir.
class RecordPayment implements UseCase<Payment, RecordPaymentParams> {
  final PaymentRepository repository;
  const RecordPayment(this.repository);

  @override
  Future<Either<Failure, Payment>> call(RecordPaymentParams params) {
    final payment = params.payment;
    final newPaidAmount =
        (payment.paidAmount + params.amountReceived).clamp(0, payment.amount);

    final newStatus = newPaidAmount >= payment.amount
        ? PaymentStatus.paid
        : (newPaidAmount > 0 ? PaymentStatus.partial : payment.status);

    final updated = payment.copyWith(
      paidAmount: newPaidAmount.toDouble(),
      status: newStatus,
      paidDate: newStatus == PaymentStatus.paid ? DateTime.now() : payment.paidDate,
    );

    return repository.updatePayment(updated);
  }
}
