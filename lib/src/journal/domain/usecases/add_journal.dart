import 'dart:typed_data';

import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';

class AddJournal extends FutureUsecaseWithParams<void, AddJournalParams> {
  const AddJournal(this._repo);

  final JournalRepo _repo;

  @override
  ResultFuture<void> call(AddJournalParams params) async =>
      _repo.addJournal(params.imageBytes, params.journal);
}

class AddJournalParams {
  final Uint8List imageBytes;
  final Journal journal;

  AddJournalParams(this.imageBytes, this.journal);
}
