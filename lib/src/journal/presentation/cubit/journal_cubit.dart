import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/usecases/add_journal.dart';
import 'package:memoircanvas/src/journal/domain/usecases/get_journals.dart';

part 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit({
    required AddJournal addJournal,
    required GetJournals getJournals,
  })  : _addJournal = addJournal,
        _getJournals = getJournals,
        super(const JournalInitial());

  final AddJournal _addJournal;
  final GetJournals _getJournals;

  Future<void> addJournal(AddJournalParams params) async {
    emit(const AddingJournal());
    final result = await _addJournal(params);
    result.fold(
      (failure) => emit(JournalError(failure.errorMessage)),
      (_) => emit(const JournalAdded()),
    );
  }

  Future<void> getJournals() async {
    emit(const LoadingJournals());
    final result = await _getJournals();
    result.fold(
      (failure) => emit(JournalError(failure.errorMessage)),
      (journals) => emit(JournalsLoaded(journals)),
    );
  }
}
