part of 'journal_cubit.dart';

sealed class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object> get props => [];
}

class JournalInitial extends JournalState {
  const JournalInitial();
}

class LoadingJournals extends JournalState {
  const LoadingJournals();
}

class AddingJournal extends JournalState {
  const AddingJournal();
}

class JournalAdded extends JournalState {
  const JournalAdded();
}

class JournalsLoaded extends JournalState {
  const JournalsLoaded(this.journals);

  final List<Journal> journals;

  @override
  List<Object> get props => [journals];
}

class JournalError extends JournalState {
  const JournalError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
