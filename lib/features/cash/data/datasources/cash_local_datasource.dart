import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;

abstract class CashLocalDataSource {
  Future<List<db.CashTransaction>> getTransactions();
  Future<db.CashTransaction> addTransaction(
    db.CashTransactionsCompanion transaction,
  );
  Future<db.CashTransaction> updateTransaction(
    int id,
    db.CashTransactionsCompanion transaction,
  );
  Future<void> deleteTransaction(int id);
}

class CashLocalDataSourceImpl implements CashLocalDataSource {
  final db.AppDatabase database;
  const CashLocalDataSourceImpl(this.database);

  @override
  Future<List<db.CashTransaction>> getTransactions() {
    return (database.select(database.cashTransactions)
          ..orderBy([
            (t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc),
          ]))
        .get();
  }

  Future<db.CashTransaction> _getById(int id) {
    return (database.select(
      database.cashTransactions,
    )..where((t) => t.id.equals(id))).getSingle();
  }

  @override
  Future<db.CashTransaction> addTransaction(
    db.CashTransactionsCompanion transaction,
  ) async {
    final id = await database.into(database.cashTransactions).insert(transaction);
    return _getById(id);
  }

  @override
  Future<db.CashTransaction> updateTransaction(
    int id,
    db.CashTransactionsCompanion transaction,
  ) async {
    await (database.update(
      database.cashTransactions,
    )..where((t) => t.id.equals(id))).write(transaction);
    return _getById(id);
  }

  @override
  Future<void> deleteTransaction(int id) {
    return (database.delete(
      database.cashTransactions,
    )..where((t) => t.id.equals(id))).go();
  }
}
