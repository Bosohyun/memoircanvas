import 'package:dartz/dartz.dart';
import 'package:memoircanvas/core/errors/failures.dart';

typedef ResultFuture<T> = Future<Either<Failure, T>>;
typedef DataMap = Map<String, dynamic>;
