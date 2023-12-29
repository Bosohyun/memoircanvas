import 'dart:convert';
import 'dart:typed_data';
import 'package:fast_image_resizer/fast_image_resizer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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
  Future<String> genJournalImage(String journal);
  Future<void> deleteJournal(String journalId);
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
      //query Today's journal
      DateTime today = DateTime.now();
      DateTime startOfDay = DateTime(today.year, today.month, today.day);
      DateTime endOfDay =
          DateTime(today.year, today.month, today.day, 23, 59, 59);

      final existingJournalSnapshot = await _firestore
          .collection('journals')
          .where('userId', isEqualTo: user.uid)
          .where('createdAt', isGreaterThanOrEqualTo: startOfDay)
          .where('createdAt', isLessThanOrEqualTo: endOfDay)
          .limit(1)
          .get();

      final DocumentReference journalRef;
      JournalModel journalModel;

      if (existingJournalSnapshot.docs.isNotEmpty) {
        journalRef = existingJournalSnapshot.docs.first.reference;
        journalModel =
            JournalModel.fromMap(existingJournalSnapshot.docs.first.data())
                .copyWith(
          id: journalRef.id,
          userId: user.uid,
          weather: journal.weather,
          diary: journal.diary,
          title: journal.title,
          createdAt: DateTime.now(),
        );
      } else {
        journalRef = _firestore.collection('journals').doc();
        journalModel = (journal as JournalModel).copyWith(
          id: journalRef.id,
          userId: user.uid,
        );
      }

      final timestamp = DateTime.now().microsecondsSinceEpoch;
      final resizedImageBytes = await resizeImage(
              Uint8List.view(imageBytes.buffer),
              height: 256,
              width: 256)
          .then((value) => value!.buffer.asUint8List());

      final imageRef = _storage.ref().child('journals/${user.uid}/$timestamp');
      await imageRef
          .putData(
              resizedImageBytes, SettableMetadata(contentType: 'image/png'))
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

  @override
  Future<String> genJournalImage(String journal) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated',
        statusCode: '401',
      );
    }

    try {
      final uri = Uri.parse('https://api.openai.com/v1/images/generations');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}}',
      };

      final body = jsonEncode(
        {"model": "dall-e-2", "prompt": journal, "n": 1, "size": "1024x1024"},
      );

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['data'][0]['url'];
      } else {
        throw const ServerException(
            message: 'Failed to generate image', statusCode: '505');
      }
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '504');
    }
  }

  @override
  Future<void> deleteJournal(String journalId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw const ServerException(
        message: 'User is not authenticated',
        statusCode: '401',
      );
    }
    try {
      await _firestore.collection('journals').doc(journalId).delete();
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
