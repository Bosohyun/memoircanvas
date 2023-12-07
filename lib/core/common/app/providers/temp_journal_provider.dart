import 'package:flutter/foundation.dart';

import 'package:memoircanvas/src/journal/data/models/journal_model.dart';

class TempJournalProvider extends ChangeNotifier {
  JournalModel? _tempJournal;

  JournalModel? get tempJournal => _tempJournal;

  void initTempJournal(JournalModel? tempJournal) {
    if (_tempJournal != tempJournal) _tempJournal = tempJournal;
  }

  set user(JournalModel? tempJournal) {
    if (_tempJournal != tempJournal) _tempJournal = tempJournal;
    Future.delayed(Duration.zero, notifyListeners);
  }
}


// By using Future.delayed(Duration.zero, ...), 
//you ensure that notifyListeners is called after the build phase is completed, 
//thus avoiding any potential conflicts with the build process.