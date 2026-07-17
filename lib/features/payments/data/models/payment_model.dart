import '../../../../core/database/app_database.dart' as db;
import '../../../../core/enums/payment_status.dart';
import '../../domain/entities/payment.dart';

extension PaymentRowMapper on db.Payment {
  Payment toEntity() {
    return Payment(
      id: id,
      studentId: studentId,
      amount: amount,
      period: period,
      dueDate: dueDate,
      paidDate: paidDate,
      status: PaymentStatus.fromName(status),
    );
  }
}

extension PaymentEntityMapper on Payment {
  db.PaymentsCompanion toCompanion() {
    return db.PaymentsCompanion.insert(
      studentId: studentId,
      amount: amount,
      period: period,
      dueDate: dueDate,
      status: status.name,
    );
  }
}
