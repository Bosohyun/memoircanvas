import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';

class DeleteJournal extends FutureUsecaseWithParams<void, String> {
  const DeleteJournal(this._repo);

  final JournalRepo _repo;

  @override
  ResultFuture<void> call(String params) {
    return _repo.deleteJournal(params);
  }
}
