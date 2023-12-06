import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final timestampData = {
    '_seconds': 1677483548,
    '_nanoseconds': 123456000,
  };

  final date =
      DateTime.fromMillisecondsSinceEpoch(timestampData['_seconds']!).add(
    Duration(
      microseconds: timestampData['_nanoseconds']!,
    ),
  );

  final timestamp = Timestamp.fromDate(date);

  final tJournalModel = JournalModel.empty();

  final tMap = jsonDecode(fixture('journal.json')) as DataMap;
  tMap['createdAt'] = timestamp;

  test('should be a subclass of [Journal] entity', () {
    expect(tJournalModel, isA<Journal>());
  });

  group('empty', () {
    test('should return an empty [JournalModel] instance', () {
      final result = JournalModel.empty();
      expect(result.title, '_empty.title');
    });
  });

  group('fromMap', () {
    test('should return a valid [JournalModel] instance', () {
      final result = JournalModel.fromMap(tMap);
      expect(result, equals(tJournalModel));
    });
  });

  group('copyWith', () {
    test('should return a valid [JournalModel] instance', () async {
      final result = tJournalModel.copyWith(title: 'New Title');

      expect(result.title, 'New Title');
    });
  });
}
