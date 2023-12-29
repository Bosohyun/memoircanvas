import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';
import 'package:memoircanvas/src/journal/domain/usecases/add_journal.dart';
import 'package:memoircanvas/src/journal/domain/usecases/delete_journal.dart';
import 'package:memoircanvas/src/journal/domain/usecases/gen_journal_image.dart';
import 'package:memoircanvas/src/journal/domain/usecases/get_journals.dart';

part 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit({
    required AddJournal addJournal,
    required GetJournals getJournals,
    required GenJournalImage genJournalImage,
    required DeleteJournal deleteJournal,
  })  : _addJournal = addJournal,
        _getJournals = getJournals,
        _genJournalImage = genJournalImage,
        _deleteJournal = deleteJournal,
        super(const JournalInitial());

  final AddJournal _addJournal;
  final GetJournals _getJournals;
  final GenJournalImage _genJournalImage;
  final DeleteJournal _deleteJournal;

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

  Future<void> genJournalImage(String journal) async {
    emit(const JournalImageGenerating());
    final result = await _genJournalImage(journal);
    result.fold(
      (failure) => emit(JournalError(failure.errorMessage)),
      (imageUrl) => emit(JournalImageGenerated(imageUrl)),
    );
  }

  Future<void> deleteJournal(String journalId) async {
    emit(const DeletingJournal());
    final result = await _deleteJournal(journalId);
    result.fold((failure) => emit(JournalError(failure.errorMessage)),
        (_) => emit(const JournalDeleted()));
  }

  Future<void> reset() async {
    emit(const JournalInitial());
  }
}
