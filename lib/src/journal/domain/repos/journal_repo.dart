import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

abstract class JournalRepo {
  const JournalRepo();

  ResultFuture<List<Journal>> getJournals();

  ResultFuture<void> addJournal(Journal journal);

  ResultFuture<String> generateJournalImage(String text);
}
