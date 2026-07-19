import 'package:drift/drift.dart';

/// Kasa hareketleri: her satır bir gelir ya da gider kaydı.
/// type: CashType enum'unun `name` değeri ("income" / "expense").
class CashTransactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 150)();
  RealColumn get amount => real()();
  TextColumn get type => text()();
  DateTimeColumn get date => dateTime()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
