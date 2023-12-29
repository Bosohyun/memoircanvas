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

class DeletingJournal extends JournalState {
  const DeletingJournal();
}

class JournalDeleted extends JournalState {
  const JournalDeleted();
}

class JournalError extends JournalState {
  const JournalError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class JournalImageGenerating extends JournalState {
  const JournalImageGenerating();
}

class JournalImageGenerated extends JournalState {
  const JournalImageGenerated(this.imageUrl);

  final String imageUrl;

  @override
  List<Object> get props => [imageUrl];
}

class JournalImageGenError extends JournalState {
  const JournalImageGenError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
