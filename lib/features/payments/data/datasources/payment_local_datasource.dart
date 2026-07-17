import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;

abstract class PaymentLocalDataSource {
  Future<List<db.Payment>> getPayments();
  Future<List<db.Payment>> getPaymentsByStudent(int studentId);
  Future<db.Payment> addPayment(db.PaymentsCompanion payment);
  Future<db.Payment> updatePayment(int id, db.PaymentsCompanion payment);
  Future<void> deletePayment(int id);
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  final db.AppDatabase database;
  const PaymentLocalDataSourceImpl(this.database);

  @override
  Future<List<db.Payment>> getPayments() {
    return (database.select(database.payments)
          ..orderBy([(t) => OrderingTerm(expression: t.dueDate)]))
        .get();
  }

  @override
  Future<List<db.Payment>> getPaymentsByStudent(int studentId) {
    return (database.select(database.payments)
          ..where((t) => t.studentId.equals(studentId))
          ..orderBy([(t) => OrderingTerm(expression: t.dueDate)]))
        .get();
  }

  Future<db.Payment> _getById(int id) {
    return (database.select(database.payments)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  @override
  Future<db.Payment> addPayment(db.PaymentsCompanion payment) async {
    final id = await database.into(database.payments).insert(payment);
    return _getById(id);
  }

  @override
  Future<db.Payment> updatePayment(
    int id,
    db.PaymentsCompanion payment,
  ) async {
    await (database.update(database.payments)..where((t) => t.id.equals(id)))
        .write(payment);
    return _getById(id);
  }

  @override
  Future<void> deletePayment(int id) {
    return (database.delete(database.payments)..where((t) => t.id.equals(id)))
        .go();
  }
}
