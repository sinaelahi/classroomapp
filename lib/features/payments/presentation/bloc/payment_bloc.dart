import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/add_payment.dart';
import '../../domain/usecases/delete_payment.dart';
import '../../domain/usecases/get_payment_summary.dart';
import '../../domain/usecases/get_payments.dart';
import '../../domain/usecases/record_payment.dart';
import '../../domain/usecases/update_payment.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final GetPayments getPayments;
  final AddPayment addPayment;
  final UpdatePayment updatePayment;
  final DeletePayment deletePayment;
  final RecordPayment recordPayment;
  final GetPaymentSummary getPaymentSummary;

  PaymentBloc({
    required this.getPayments,
    required this.addPayment,
    required this.updatePayment,
    required this.deletePayment,
    required this.recordPayment,
    required this.getPaymentSummary,
  }) : super(const PaymentState()) {
    on<LoadPayments>(_onLoadPayments);
    on<AddPaymentRequested>(_onAddPayment);
    on<RecordPaymentRequested>(_onRecordPayment);
    on<UpdatePaymentRequested>(_onUpdatePayment);
    on<DeletePaymentRequested>(_onDeletePayment);
  }

  Future<void> _onLoadPayments(
    LoadPayments event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatusFlag.loading));

    final paymentsResult = await getPayments(const NoParams());
    final summaryResult = await getPaymentSummary(const NoParams());

    paymentsResult.match(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatusFlag.failure,
          errorMessage: failure.message,
        ),
      ),
      (payments) {
        summaryResult.match(
          (failure) => emit(
            state.copyWith(
              status: PaymentStatusFlag.success,
              payments: payments,
            ),
          ),
          (summary) => emit(
            state.copyWith(
              status: PaymentStatusFlag.success,
              payments: payments,
              summary: summary,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onAddPayment(
    AddPaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    final result = await addPayment(
      AddPaymentParams(
        studentId: event.studentId,
        amount: event.amount,
        period: event.period,
        dueDate: event.dueDate,
      ),
    );
    result.match(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatusFlag.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadPayments()),
    );
  }

  Future<void> _onRecordPayment(
    RecordPaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    final result = await recordPayment(
      RecordPaymentParams(
        payment: event.payment,
        amountReceived: event.amountReceived,
      ),
    );
    result.match(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatusFlag.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadPayments()),
    );
  }

  Future<void> _onUpdatePayment(
    UpdatePaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    final result = await updatePayment(event.payment);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatusFlag.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadPayments()),
    );
  }

  Future<void> _onDeletePayment(
    DeletePaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    final result = await deletePayment(event.id);
    result.match(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatusFlag.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => add(const LoadPayments()),
    );
  }
}
