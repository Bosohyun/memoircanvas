import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoircanvas/core/errors/exceptions.dart';
import 'package:memoircanvas/core/errors/failures.dart';
import 'package:memoircanvas/src/journal/data/datasources/journal_remote_data_src.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/data/repos/journal_repo_impl.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:mocktail/mocktail.dart';

class MockJournalRemoteDataSrc extends Mock implements JournalRemoteDataSrc {}

void main() {
  late JournalRemoteDataSrc remoteDataSrc;
  late JournalRepoImpl repoImpl;

  final tJournal = JournalModel.empty();

  setUp(() {
    remoteDataSrc = MockJournalRemoteDataSrc();
    repoImpl = JournalRepoImpl(remoteDataSrc);
    registerFallbackValue(tJournal);
  });

  const tException = ServerException(
    message: 'Something went wrong',
    statusCode: '500',
  );

  group('addJournal', () {
    test(
      'should complete succeefully when call to remote source is successful',
      () async {
        when(() => remoteDataSrc.addJournal(any())).thenAnswer(
          (_) async => Future.value(),
        );

        final result = await repoImpl.addJournal(tJournal);
        expect(result, const Right<dynamic, void>(null));
        verify(() => remoteDataSrc.addJournal(tJournal)).called(1);
        verifyNoMoreInteractions(remoteDataSrc);
      },
    );

    test(
        'should retrun [ServerFailure] when call to remote source is '
        'unsuccessful', () async {
      when(() => remoteDataSrc.addJournal(any())).thenThrow(tException);

      final result = await repoImpl.addJournal(tJournal);
      expect(
        result,
        Left<Failure, void>(ServerFailure.fromException(tException)),
      );

      verify(() => remoteDataSrc.addJournal(tJournal)).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });

  group('getJournals', () {
    test(
        'should return [List<Course>] when call to remote source is successful',
        () async {
      when(() => remoteDataSrc.getJournals())
          .thenAnswer((_) async => [tJournal]);

      final result = await repoImpl.getJournals();
      expect(result, isA<Right<dynamic, List<Journal>>>);

      verify(() => remoteDataSrc.getJournals()).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });

    test(
        'should return [ServerFailure] when call to remote source is '
        'unsuccessful', () async {
      when(() => remoteDataSrc.getJournals()).thenThrow(tException);

      final result = await repoImpl.getJournals();

      expect(result,
          Left<Failure, dynamic>(ServerFailure.fromException(tException)));

      verify(() => remoteDataSrc.getJournals()).called(1);
      verifyNoMoreInteractions(remoteDataSrc);
    });
  });
}
