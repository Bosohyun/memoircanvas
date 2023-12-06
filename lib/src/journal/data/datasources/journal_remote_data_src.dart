import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memoircanvas/core/errors/exceptions.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

abstract class JournalRemoteDataSrc {
  const JournalRemoteDataSrc();

  Future<List<JournalModel>> getJournals();
  Future<void> addJournal(Journal journal);
}

class JournalRemoteDataSrcImpl extends JournalRemoteDataSrc {
  const JournalRemoteDataSrcImpl({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _storage = storage,
        _auth = auth;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final FirebaseAuth _auth;

  @override
  Future<List<JournalModel>> getJournals() {
    // TODO: implement getCourses
    throw UnimplementedError();
  }

  @override
  Future<void> addJournal(Journal journal) {
    // TODO: implement addJournal
    throw UnimplementedError();
  }
}
