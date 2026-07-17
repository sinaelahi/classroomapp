import 'package:drift/drift.dart';

/// Öğrenciler tablosu.
/// classLevel, ClassLevel enum'unun `name` değeri olarak (örn. "sinif8") saklanır.
class Students extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firstName => text().withLength(min: 1, max: 100)();
  TextColumn get lastName => text().withLength(min: 1, max: 100)();
  TextColumn get phoneNumber => text().withLength(min: 10, max: 20)();
  TextColumn get classLevel => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
