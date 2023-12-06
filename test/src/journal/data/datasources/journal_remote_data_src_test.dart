import 'dart:typed_data';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:memoircanvas/src/journal/data/datasources/journal_remote_data_src.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:memoircanvas/src/journal/data/models/journal_model.dart';

void main() {
  late JournalRemoteDataSrc remoteDataSource;
  late FakeFirebaseFirestore firestore;
  late MockFirebaseAuth auth;
  late MockFirebaseStorage storage;

  setUp(() async {
    firestore = FakeFirebaseFirestore();

    final user = MockUser(
      uid: 'uid',
      email: 'email',
      displayName: 'displayName',
    );

    final googleSignIn = MockGoogleSignIn();
    final signInAccount = await googleSignIn.signIn();
    final googleAuth = await signInAccount!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    auth = MockFirebaseAuth(mockUser: user);
    await auth.signInWithCredential(credential);

    storage = MockFirebaseStorage();

    remoteDataSource = JournalRemoteDataSrcImpl(
      firestore: firestore,
      storage: storage,
      auth: auth,
    );
  });
  group('addJournal', () {
    test(
      'should add the given course to the firestore collection',
      () async {
        // Arrange
        final journal = JournalModel.empty();
        final Uint8List tImageBytes = Uint8List(0);

        // Act
        await remoteDataSource.addJournal(tImageBytes, journal);

        // Assert
        final firestoreData = await firestore.collection('journals').get();
        expect(firestoreData.docs.length, 1);

        final journalRef = firestoreData.docs.first;
        expect(journalRef.data()['id'], journalRef.id);

        expect(journalRef.data()['userId'], auth.currentUser!.uid);
      },
    );
  });

  group('getCourses', () {
    test(
      'should return a List<Course> when the call is successful',
      () async {
        // Arrange
        final firstDate = DateTime.now();
        final secondDate = DateTime.now().add(const Duration(seconds: 20));
        final inputJournals = [
          JournalModel.empty().copyWith(
            createdAt: secondDate,
            id: '1',
            userId: auth.currentUser!.uid,
            title: 'Journal 1',
          ),
          JournalModel.empty().copyWith(
            createdAt: secondDate,
            id: '2',
            userId: auth.currentUser!.uid,
            title: 'Journal 2',
          ),
          JournalModel.empty().copyWith(
            createdAt: secondDate,
            id: '3',
            userId: 'dummy Id',
            title: 'Journal 3',
          ),
        ];

        final expectedJournals = [
          JournalModel.empty().copyWith(
            createdAt: secondDate,
            id: '1',
            userId: auth.currentUser!.uid,
            title: 'Journal 1',
          ),
          JournalModel.empty().copyWith(
            createdAt: secondDate,
            id: '2',
            userId: auth.currentUser!.uid,
            title: 'Journal 2',
          ),
        ];

        for (final course in inputJournals) {
          await firestore.collection('journals').add(course.toMap());
        }

        // Act
        final result = await remoteDataSource.getJournals();

        // Assert
        expect(result, expectedJournals);
      },
    );
  });
}



//   group('addCourse', () {
//     test(
//       'should add the given course to the firestore collection',
//       () async {
//         // Arrange
//         final course = CourseModel.empty();

//         // Act
//         await remoteDataSource.addCourse(course);

//         // Assert
//         final firestoreData = await firestore.collection('courses').get();
//         expect(firestoreData.docs.length, 1);

//         final courseRef = firestoreData.docs.first;
//         expect(courseRef.data()['id'], courseRef.id);

//         final groupData = await firestore.collection('groups').get();
//         expect(groupData.docs.length, 1);

//         final groupRef = groupData.docs.first;
//         expect(groupRef.data()['id'], groupRef.id);

//         expect(courseRef.data()['groupId'], groupRef.id);
//         expect(groupRef.data()['courseId'], courseRef.id);
//       },
//     );
//   });

//   group('getCourses', () {
//     test(
//       'should return a List<Course> when the call is successful',
//       () async {
//         // Arrange
//         final firstDate = DateTime.now();
//         final secondDate = DateTime.now().add(const Duration(seconds: 20));
//         final expectedCourses = [
//           CourseModel.empty().copyWith(createdAt: firstDate),
//           CourseModel.empty().copyWith(
//             createdAt: secondDate,
//             id: '1',
//             title: 'Course 1',
//           ),
//         ];

//         for(final course in expectedCourses) {
//           await firestore.collection('courses').add(course.toMap());
//         }

//         // Act
//         final result = await remoteDataSource.getCourses();

//         // Assert
//         expect(result, expectedCourses);
//       },
//     );
//   });