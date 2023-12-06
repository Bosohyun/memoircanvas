import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';

class GetJournals extends FutureUsecaseWithoutParams<List<Journal>> {
  const GetJournals(this._repo);

  final JournalRepo _repo;

  @override
  ResultFuture<List<Journal>> call() {
    return _repo.getJournals();
  }
}
