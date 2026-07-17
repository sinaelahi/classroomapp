import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/student_local_datasource.dart';
import '../models/student_model.dart';

class StudentRepositoryImpl implements StudentRepository {
  final StudentLocalDataSource localDataSource;
  const StudentRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Student>>> getStudents() async {
    try {
      final rows = await localDataSource.getStudents();
      return Right(rows.map((r) => r.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure('Öğrenciler yüklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, Student>> getStudentById(int id) async {
    try {
      final row = await localDataSource.getStudentById(id);
      return Right(row.toEntity());
    } catch (e) {
      return Left(NotFoundFailure('Öğrenci bulunamadı: $e'));
    }
  }

  @override
  Future<Either<Failure, Student>> addStudent(Student student) async {
    try {
      final row = await localDataSource.addStudent(student.toCompanion());
      return Right(row.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Öğrenci eklenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, Student>> updateStudent(Student student) async {
    try {
      final row = await localDataSource.updateStudent(
        student.id!,
        student.toCompanion(),
      );
      return Right(row.toEntity());
    } catch (e) {
      return Left(DatabaseFailure('Öğrenci güncellenirken hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(int id) async {
    try {
      await localDataSource.deleteStudent(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure('Öğrenci silinirken hata oluştu: $e'));
    }
  }
}
