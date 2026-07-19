import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;
import '../../../../core/enums/class_level.dart';
import '../../../../core/enums/gender.dart';
import '../../domain/entities/student.dart';

/// drift'in ürettiği satır sınıfı (db.Student) ile domain entity'si (Student)
/// isim çakışmasın diye database importu `db` prefix'i ile yapılıyor.
extension StudentRowMapper on db.Student {
  Student toEntity() {
    return Student(
      id: id,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      classLevel: ClassLevel.fromName(classLevel),
      gender: Gender.fromName(gender),
      createdAt: createdAt,
    );
  }
}

extension StudentEntityMapper on Student {
  db.StudentsCompanion toCompanion() {
    return db.StudentsCompanion.insert(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
      classLevel: classLevel.name,
      gender: Value(gender.name),
    );
  }
}
