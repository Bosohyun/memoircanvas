import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:memoircanvas/core/errors/failures.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/domain/usecases/add_journal.dart';
import 'package:memoircanvas/src/journal/domain/usecases/gen_journal_image.dart';
import 'package:memoircanvas/src/journal/domain/usecases/get_journals.dart';
import 'package:memoircanvas/src/journal/presentation/cubit/journal_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockAddJournal extends Mock implements AddJournal {}

class MockGetJournals extends Mock implements GetJournals {}

class MockGenJournalImage extends Mock implements GenJournalImage {}

void main() {
  late AddJournal addJournal;
  late GetJournals getJournals;
  late GenJournalImage genJournalImage;
  late JournalCubit journalCubit;

  final tJournal = JournalModel.empty();

  setUp(() {
    addJournal = MockAddJournal();
    getJournals = MockGetJournals();
    genJournalImage = MockGenJournalImage();
    journalCubit = JournalCubit(
      addJournal: addJournal,
      getJournals: getJournals,
      genJournalImage: genJournalImage,
    );
    registerFallbackValue(tJournal);
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(AddJournalParams(
      Uint8List(0),
      tJournal,
    ));
  });

  final tParam = AddJournalParams(
    Uint8List(0),
    tJournal,
  );

  tearDown(() {
    journalCubit.close();
  });

  test(
    'initial state should be [CourseInitial]',
    () async {
      expect(journalCubit.state, const JournalInitial());
    },
  );

  group('addCourse', () {
    blocTest<JournalCubit, JournalState>(
      'emits [AddingCourse, CourseAdded] when addCourse is called',
      build: () {
        when(() => addJournal(any()))
            .thenAnswer((_) async => const Right(null));
        return journalCubit;
      },
      act: (cubit) => cubit.addJournal(tParam),
      expect: () => const <JournalState>[
        AddingJournal(),
        JournalAdded(),
      ],
      verify: (_) {
        verify(() => addJournal(tParam)).called(1);
        verifyNoMoreInteractions(addJournal);
      },
    );

    blocTest<JournalCubit, JournalState>(
      'emits [AddingJournal, JournalError] when addCourse is called',
      build: () {
        when(() => addJournal(any())).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return journalCubit;
      },
      act: (cubit) => cubit.addJournal(tParam),
      expect: () => const <JournalState>[
        AddingJournal(),
        JournalError('500 Error : Something went wrong'),
      ],
      verify: (_) {
        verify(() => addJournal(tParam)).called(1);
        verifyNoMoreInteractions(addJournal);
      },
    );
  });

  group('getCourses', () {
    blocTest<JournalCubit, JournalState>(
      'emits [CourseLoading, CoursesLoaded] when getCourses is called',
      build: () {
        when(() => getJournals()).thenAnswer((_) async => Right([tJournal]));
        return journalCubit;
      },
      act: (cubit) => cubit.getJournals(),
      expect: () => <JournalState>[
        const LoadingJournals(),
        JournalsLoaded([tJournal]),
      ],
      verify: (_) {
        verify(() => getJournals()).called(1);
        verifyNoMoreInteractions(getJournals);
      },
    );

    blocTest<JournalCubit, JournalState>(
      'emits [CourseLoading, CourseError] when getCourses is called',
      build: () {
        when(() => getJournals()).thenAnswer(
          (_) async => Left(
            ServerFailure(
              message: 'Something went wrong',
              statusCode: '500',
            ),
          ),
        );
        return journalCubit;
      },
      act: (cubit) => cubit.getJournals(),
      expect: () => const <JournalState>[
        LoadingJournals(),
        JournalError('500 Error : Something went wrong'),
      ],
      verify: (_) {
        verify(() => getJournals()).called(1);
        verifyNoMoreInteractions(getJournals);
      },
    );
  });
}
