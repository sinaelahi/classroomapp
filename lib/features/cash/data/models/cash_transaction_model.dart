import '../../../../core/database/app_database.dart' as db;
import '../../domain/entities/cash_transaction.dart';

extension CashTransactionRowMapper on db.CashTransaction {
  CashTransaction toEntity() {
    return CashTransaction(
      id: id,
      title: title,
      amount: amount,
      type: CashType.fromName(type),
      date: date,
    );
  }
}

extension CashTransactionEntityMapper on CashTransaction {
  db.CashTransactionsCompanion toCompanion() {
    return db.CashTransactionsCompanion.insert(
      title: title,
      amount: amount,
      type: type.name,
      date: date,
    );
  }
}
