import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_cash_summary.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';
import 'cash_event.dart';
import 'cash_state.dart';

class CashBloc extends Bloc<CashEvent, CashState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;
  final GetCashSummary getCashSummary;

  CashBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.updateTransaction,
    required this.deleteTransaction,
    required this.getCashSummary,
  }) : super(const CashState()) {
    on<LoadCashTransactions>(_onLoad);
    on<AddCashTransactionRequested>(_onAdd);
    on<UpdateCashTransactionRequested>(_onUpdate);
    on<DeleteCashTransactionRequested>(_onDelete);
  }

  Future<void> _onLoad(
    LoadCashTransactions event,
    Emitter<CashState> emit,
  ) async {
    emit(state.copyWith(status: CashStatus.loading));

    final transactionsResult = await getTransactions(const NoParams());
    final summaryResult = await getCashSummary(const NoParams());

    transactionsResult.match(
      (failure) => emit(
        state.copyWith(status: CashStatus.failure, errorMessage: failure.message),
      ),
      (transactions) {
        summaryResult.match(
          (failure) => emit(
            state.copyWith(status: CashStatus.success, transactions: transactions),
          ),
          (summary) => emit(
            state.copyWith(
              status: CashStatus.success,
              transactions: transactions,
              summary: summary,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAdd(
    AddCashTransactionRequested event,
    Emitter<CashState> emit,
  ) async {
    final result = await addTransaction(
      AddTransactionParams(
        title: event.title,
        amount: event.amount,
        type: event.type,
        date: event.date,
      ),
    );
    result.match(
      (failure) => emit(
        state.copyWith(status: CashStatus.failure, errorMessage: failure.message),
      ),
      (_) => add(const LoadCashTransactions()),
    );
  }

  Future<void> _onUpdate(
    UpdateCashTransactionRequested event,
    Emitter<CashState> emit,
  ) async {
    final result = await updateTransaction(event.transaction);
    result.match(
      (failure) => emit(
        state.copyWith(status: CashStatus.failure, errorMessage: failure.message),
      ),
      (_) => add(const LoadCashTransactions()),
    );
  }

  Future<void> _onDelete(
    DeleteCashTransactionRequested event,
    Emitter<CashState> emit,
  ) async {
    final result = await deleteTransaction(event.id);
    result.match(
      (failure) => emit(
        state.copyWith(status: CashStatus.failure, errorMessage: failure.message),
      ),
      (_) => add(const LoadCashTransactions()),
    );
  }
}
