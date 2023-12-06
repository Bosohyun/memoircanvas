import 'dart:ffi';
import 'dart:typed_data';

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
  final Uint8List tImageBytes = Uint8List(0);

  setUp(() {
    repo = MockJournalRepo();
    usecase = AddJournal(repo);
    registerFallbackValue(tJournal);
    registerFallbackValue(Uint8List(0));
  });

  test('should call [JournalRepo.addJournal]', () async {
    when(() => repo.addJournal(any(), any()))
        .thenAnswer((_) async => const Right(null));

    await usecase(AddJournalParams(tImageBytes, tJournal));

    verify(() => repo.addJournal(tImageBytes, tJournal)).called(1);
    verifyNoMoreInteractions(repo);
  });
}
