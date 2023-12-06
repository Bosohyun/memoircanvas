import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:memoircanvas/core/errors/exceptions.dart';

import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

abstract class JournalRemoteDataSrc {
  const JournalRemoteDataSrc();

  Future<List<JournalModel>> getJournals();
  Future<void> addJournal(Uint8List imageBytes, Journal journal);
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
  Future<void> addJournal(Uint8List imageBytes, Journal journal) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        throw const ServerException(
          message: 'User is not authenticated',
          statusCode: '401',
        );
      }

      final journalRef = _firestore.collection('journals').doc();

      var journalModel = (journal as JournalModel).copyWith(
        id: journalRef.id,
        userId: user.uid,
      );

      final timestamp = DateTime.now().microsecondsSinceEpoch;

      final imageRef = _storage.ref().child('journals/${user.uid}/$timestamp');
      await imageRef
          .putData(imageBytes, SettableMetadata(contentType: 'image/png'))
          .then((value) async {
        final url = await value.ref.getDownloadURL();
        journalModel = journalModel.copyWith(imageURL: url);
      });
      await journalRef.set(journalModel.toMap());
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  @override
  Future<List<JournalModel>> getJournals() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated',
        statusCode: '401',
      );
    }
    try {
      // Query the 'journals' collection for entries where 'userId' matches the current user's ID
      final querySnapshot = await _firestore
          .collection('journals')
          .where('userId', isEqualTo: user.uid)
          .get();

      // Map the query results to a list of JournalModel
      return querySnapshot.docs
          .map((doc) => JournalModel.fromMap(doc.data()))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Unknown error occurred',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }
}
