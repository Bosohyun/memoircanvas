import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';
import 'package:memoircanvas/src/journal/domain/usecases/add_journal.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repo.mock.dart';

void main() {
  late JournalRepo repo;
  late AddJournal usecase;

  final tJournal = Journal.empty();

  setUp(() {
    repo = MockJournalRepo();
    usecase = AddJournal(repo);
    registerFallbackValue(tJournal);
  });

  test('should call [JournalRepo.addJournal]', () async {
    when(() => repo.addJournal(any()))
        .thenAnswer((_) async => const Right(null));

    await usecase(tJournal);

    verify(() => repo.addJournal(tJournal)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
