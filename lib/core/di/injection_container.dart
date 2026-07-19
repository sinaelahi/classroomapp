import 'package:get_it/get_it.dart';
import '../database/app_database.dart';

import '../../features/students/data/datasources/student_local_datasource.dart';
import '../../features/students/data/repositories/student_repository_impl.dart';
import '../../features/students/domain/repositories/student_repository.dart';
import '../../features/students/domain/usecases/add_student.dart';
import '../../features/students/domain/usecases/delete_student.dart';
import '../../features/students/domain/usecases/get_students.dart';
import '../../features/students/domain/usecases/update_student.dart';
import '../../features/students/presentation/bloc/student_bloc.dart';

import '../../features/payments/data/datasources/payment_local_datasource.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/payments/domain/usecases/add_payment.dart';
import '../../features/payments/domain/usecases/delete_payment.dart';
import '../../features/payments/domain/usecases/get_payment_summary.dart';
import '../../features/payments/domain/usecases/get_payments.dart';
import '../../features/payments/domain/usecases/mark_as_paid.dart';
import '../../features/payments/domain/usecases/update_payment.dart';
import '../../features/payments/presentation/bloc/payment_bloc.dart';

import '../../features/cash/data/datasources/cash_local_datasource.dart';
import '../../features/cash/data/repositories/cash_repository_impl.dart';
import '../../features/cash/domain/repositories/cash_repository.dart';
import '../../features/cash/domain/usecases/add_transaction.dart';
import '../../features/cash/domain/usecases/delete_transaction.dart';
import '../../features/cash/domain/usecases/get_cash_summary.dart';
import '../../features/cash/domain/usecases/get_transactions.dart';
import '../../features/cash/domain/usecases/update_transaction.dart';
import '../../features/cash/presentation/bloc/cash_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ---- Core ----
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ---- Students feature ----
  sl.registerLazySingleton<StudentLocalDataSource>(
    () => StudentLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetStudents(sl()));
  sl.registerLazySingleton(() => AddStudent(sl()));
  sl.registerLazySingleton(() => UpdateStudent(sl()));
  sl.registerLazySingleton(() => DeleteStudent(sl()));
  sl.registerFactory(
    () => StudentBloc(
      getStudents: sl(),
      addStudent: sl(),
      updateStudent: sl(),
      deleteStudent: sl(),
    ),
  );

  // ---- Payments feature ----
  sl.registerLazySingleton<PaymentLocalDataSource>(
    () => PaymentLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PaymentRepository>(
    () => PaymentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetPayments(sl()));
  sl.registerLazySingleton(() => AddPayment(sl()));
  sl.registerLazySingleton(() => UpdatePayment(sl()));
  sl.registerLazySingleton(() => DeletePayment(sl()));
  sl.registerLazySingleton(() => MarkAsPaid(sl()));
  sl.registerLazySingleton(() => GetPaymentSummary(sl()));
  sl.registerFactory(
    () => PaymentBloc(
      getPayments: sl(),
      addPayment: sl(),
      updatePayment: sl(),
      deletePayment: sl(),
      markAsPaid: sl(),
      getPaymentSummary: sl(),
    ),
  );

  // ---- Cash feature ----
  sl.registerLazySingleton<CashLocalDataSource>(
    () => CashLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<CashRepository>(() => CashRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));
  sl.registerLazySingleton(() => GetCashSummary(sl()));
  sl.registerFactory(
    () => CashBloc(
      getTransactions: sl(),
      addTransaction: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
      getCashSummary: sl(),
    ),
  );
}
