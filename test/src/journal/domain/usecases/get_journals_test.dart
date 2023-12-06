import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';
import 'package:memoircanvas/src/journal/domain/usecases/get_journals.dart';
import 'package:mocktail/mocktail.dart';

import 'journal_repo.mock.dart';

void main() {
  late JournalRepo repo;
  late GetJournals usecase;

  setUp(() {
    repo = MockJournalRepo();
    usecase = GetJournals(repo);
  });

  test('should get courses from the repo', () async {
    when(() => repo.getJournals()).thenAnswer((_) async => const Right([]));

    final result = await usecase();

    expect(result, const Right<dynamic, List<Journal>>([]));
    verify(() => repo.getJournals()).called(1);
    verifyNoMoreInteractions(repo);
  });
}
