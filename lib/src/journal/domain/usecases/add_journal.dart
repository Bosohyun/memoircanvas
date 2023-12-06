import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';

class AddJournal extends FutureUsecaseWithParams<void, Journal> {
  const AddJournal(this._repo);

  final JournalRepo _repo;

  @override
  ResultFuture<void> call(Journal params) async => _repo.addJournal(params);
}
