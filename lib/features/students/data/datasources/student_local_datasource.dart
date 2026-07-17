import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart' as db;

abstract class StudentLocalDataSource {
  Future<List<db.Student>> getStudents();
  Future<db.Student> getStudentById(int id);
  Future<db.Student> addStudent(db.StudentsCompanion student);
  Future<db.Student> updateStudent(int id, db.StudentsCompanion student);
  Future<void> deleteStudent(int id);
}

class StudentLocalDataSourceImpl implements StudentLocalDataSource {
  final db.AppDatabase database;
  const StudentLocalDataSourceImpl(this.database);

  @override
  Future<List<db.Student>> getStudents() {
    return (database.select(database.students)
          ..orderBy([(t) => OrderingTerm(expression: t.lastName)]))
        .get();
  }

  @override
  Future<db.Student> getStudentById(int id) {
    return (database.select(database.students)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  @override
  Future<db.Student> addStudent(db.StudentsCompanion student) async {
    final id = await database.into(database.students).insert(student);
    return getStudentById(id);
  }

  @override
  Future<db.Student> updateStudent(
    int id,
    db.StudentsCompanion student,
  ) async {
    await (database.update(database.students)..where((t) => t.id.equals(id)))
        .write(student);
    return getStudentById(id);
  }

  @override
  Future<void> deleteStudent(int id) {
    return (database.delete(database.students)..where((t) => t.id.equals(id)))
        .go();
  }
}
