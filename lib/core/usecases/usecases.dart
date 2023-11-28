import 'package:memoircanvas/core/utils/typedefs.dart';

abstract class FutureUsecaseWithParams<Type, Params> {
  const FutureUsecaseWithParams();

  ResultFuture<Type> call(Params params);
}

abstract class FutureUsecaseWithoutParams<Type> {
  const FutureUsecaseWithoutParams();

  ResultFuture<Type> call();
}
