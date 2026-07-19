import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/students_table.dart';
import 'tables/payments_table.dart';
import 'tables/cash_transactions_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Students, Payments, CashTransactions])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
      },
      onUpgrade: (m, from, to) async {
        // v1 -> v2: kasa (gelir/gider) sistemi eklendi.
        if (from < 2) {
          await m.createTable(cashTransactions);
        }
        // v2 -> v3: öğrencilere cinsiyet (gender) alanı eklendi.
        if (from < 3) {
          await m.addColumn(students, students.gender);
        }
        // v3 -> v4: ödemelere kısmi ödeme takibi (paidAmount) eklendi.
        if (from < 4) {
          await m.addColumn(payments, payments.paidAmount);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    // drift_flutter, masaüstü (Windows/macOS/Linux) ve web için doğru
    // bağlantıyı otomatik seçer. Web'de sqlite3.wasm + drift_worker.js
    // dosyalarına ihtiyaç var; bunlar web/ klasörüne konulmalı (bkz. README).
    return driftDatabase(
      name: 'dershane_db',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }
}
