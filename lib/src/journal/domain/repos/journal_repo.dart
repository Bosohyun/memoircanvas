import 'dart:typed_data';

import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

abstract class JournalRepo {
  const JournalRepo();

  ResultFuture<List<Journal>> getJournals();

  ResultFuture<void> addJournal(Uint8List imageBytes, Journal journal);

  ResultFuture<String> genJournalImage(String journal);

  ResultFuture<void> deleteJournal(String journalId);
}
