import 'package:fpdart/fpdart.dart';
import 'package:myapp/core/error/failure.dart';

abstract interface class StreamUseCase<SuccessType, Params> {
  Either<Failure, Stream<SuccessType>> call(Params params);
}
