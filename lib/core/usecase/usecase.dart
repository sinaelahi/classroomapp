import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import '../error/failures.dart';

/// Tüm use case'lerin uyduğu kontrat.
/// [Type]  : başarılı sonuçta dönecek veri tipi
/// [Params]: use case'e verilecek parametre tipi
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Parametre almayan use case'ler için.
class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object?> get props => [];
}
