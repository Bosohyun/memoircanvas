import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  JournalCubit() : super(JournalInitial());
}
