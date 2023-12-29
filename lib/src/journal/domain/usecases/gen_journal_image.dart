import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';

class GenJournalImage extends FutureUsecaseWithParams<String, String> {
  const GenJournalImage(this._repo);

  final JournalRepo _repo;

  @override
  ResultFuture<String> call(String params) {
    return _repo.genJournalImage(params);
  }
}
