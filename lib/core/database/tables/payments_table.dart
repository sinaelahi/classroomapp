import 'package:drift/drift.dart';
import 'students_table.dart';

/// Ödemeler tablosu. Her satır bir öğrencinin belirli bir dönem (ay) için
/// ödemesini temsil eder. status: PaymentStatus enum'unun `name` değeri.
class Payments extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get studentId =>
      integer().references(Students, #id, onDelete: KeyAction.cascade)();

  RealColumn get amount => real()();

  /// Örn: "Ocak 2026", "Şubat 2026"
  TextColumn get period => text().withLength(min: 1, max: 50)();

  DateTimeColumn get dueDate => dateTime()();
  DateTimeColumn get paidDate => dateTime().nullable()();

  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
