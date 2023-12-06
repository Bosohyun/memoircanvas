import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:memoircanvas/core/errors/exceptions.dart';
import 'package:memoircanvas/core/errors/failures.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/journal/data/datasources/journal_remote_data_src.dart';
import 'package:memoircanvas/src/journal/domain/entities/journal.dart';

import 'package:memoircanvas/src/journal/domain/repos/journal_repo.dart';

class JournalRepoImpl implements JournalRepo {
  const JournalRepoImpl(this._remoteDataSrc);

  final JournalRemoteDataSrc _remoteDataSrc;

  @override
  ResultFuture<void> addJournal(Uint8List imageBytes, Journal journal) async {
    try {
      await _remoteDataSrc.addJournal(imageBytes, journal);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  ResultFuture<List<Journal>> getJournals() async {
    try {
      final journals = await _remoteDataSrc.getJournals();
      return Right(journals);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }
}
