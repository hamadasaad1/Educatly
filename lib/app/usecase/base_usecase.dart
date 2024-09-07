import 'package:dartz/dartz.dart';

import '../error/failure.dart';

/// It's a class that takes an input and returns an output wrapped in an Either
abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
