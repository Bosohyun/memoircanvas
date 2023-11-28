import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/on_boarding/domain/repos/on_boarding_repo.dart';

class CacheFirstTimer extends FutureUsecaseWithoutParams<void> {
  const CacheFirstTimer(this._repo);

  final OnBoardingRepo _repo;

  @override
  ResultFuture<void> call() => _repo.cacheFirstTimer();
}
