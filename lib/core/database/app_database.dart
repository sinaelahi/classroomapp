import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/students_table.dart';
import 'tables/payments_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Students, Payments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      // İleride tablo değişikliği yapınca buraya onUpgrade adımları eklenecek.
    );
  }

  static QueryExecutor _openConnection() {
    // drift_flutter, masaüstü (Windows/macOS/Linux) ve mobil için
    // doğru sqlite bağlantısını otomatik seçer, dosyayı uygulamanın
    // application-support klasörüne koyar.
    return driftDatabase(name: 'dershane_db');
  }
}
