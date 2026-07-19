import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_student.dart';
import '../../domain/usecases/delete_student.dart';
import '../../domain/usecases/get_students.dart';
import '../../domain/usecases/update_student.dart';
import 'student_event.dart';
import 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final GetStudents getStudents;
  final AddStudent addStudent;
  final UpdateStudent updateStudent;
  final DeleteStudent deleteStudent;

  StudentBloc({
    required this.getStudents,
    required this.addStudent,
    required this.updateStudent,
    required this.deleteStudent,
  }) : super(const StudentState()) {
    on<LoadStudents>(_onLoadStudents);
    on<AddStudentRequested>(_onAddStudent);
    on<UpdateStudentRequested>(_onUpdateStudent);
    on<DeleteStudentRequested>(_onDeleteStudent);
  }

  Future<void> _onLoadStudents(
    LoadStudents event,
    Emitter<StudentState> emit,
  ) async {
    emit(state.copyWith(status: StudentStatus.loading));
    final result = await getStudents(const NoParams());
    result.match(
      (failure) => emit(
        state.copyWith(
          status: StudentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (students) => emit(
        state.copyWith(status: StudentStatus.success, students: students),
      ),
    );
  }

  Future<void> _onAddStudent(
    AddStudentRequested event,
    Emitter<StudentState> emit,
  ) async {
    final result = await addStudent(
      AddStudentParams(
        firstName: event.firstName,
        lastName: event.lastName,
        phoneNumber: event.phoneNumber,
        classLevel: event.classLevel,
        gender: event.gender,
      ),
    );
    result.match(
      (failure) => emit(
        state.copyWith(
          status: StudentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadStudents()),
    );
  }

  Future<void> _onUpdateStudent(
    UpdateStudentRequested event,
    Emitter<StudentState> emit,
  ) async {
    final result = await updateStudent(event.student);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: StudentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadStudents()),
    );
  }

  Future<void> _onDeleteStudent(
    DeleteStudentRequested event,
    Emitter<StudentState> emit,
  ) async {
    final result = await deleteStudent(event.id);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: StudentStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadStudents()),
    );
  }
}
