import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memoircanvas/core/enums/updata_user.dart';
import 'package:memoircanvas/core/errors/exceptions.dart';

import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> forgotPassword(String email);

  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  });

  Future<LocalUserModel> signInWithGoogle();

  Future<void> signUp(
      {required String email,
      required String password,
      required String fullName});

  Future<void> updateUser({
    required UpdateUserAction action,
    dynamic userData,
  });
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl({
    required FirebaseAuth authClient,
    required FirebaseFirestore cloudStoreClient,
    required FirebaseStorage dbClient,
    required GoogleSignIn googleSignIn,
  })  : _authClient = authClient,
        _cloudStoreClient = cloudStoreClient,
        _dbClient = dbClient,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _authClient;
  final FirebaseFirestore _cloudStoreClient;
  final FirebaseStorage _dbClient;
  final GoogleSignIn _googleSignIn;

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _authClient.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ouccured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<LocalUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authClient.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = result.user;

      if (user == null) {
        throw const ServerException(
          message: 'Please try again later',
          statusCode: 'Unkown Error',
        );
      }

      if (user.emailVerified == false) {
        throw const ServerException(
          message: 'Please verify your email',
          statusCode: 'Unkown Error',
        );
      }

      var userData = await _getUserData(user.uid);

      if (userData.exists) {
        return LocalUserModel.fromMap(userData.data()!);
      }

      await _setUserData(user, email);

      userData = await _getUserData(user.uid);

      return LocalUserModel.fromMap(userData.data()!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ouccured',
        statusCode: e.code,
      );
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<LocalUserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _authClient.signInWithCredential(credential);

        final user = userCredential.user;

        if (user == null) {
          throw const ServerException(
            message: 'Please try again later',
            statusCode: 'Unkown Error',
          );
        }

        var userData = await _getUserData(user.uid);

        if (userData.exists) {
          return LocalUserModel.fromMap(userData.data()!);
        }

        await _setUserData(user, googleSignInAccount.email);

        userData = await _getUserData(user.uid);

        return LocalUserModel.fromMap(userData.data()!);
      } on FirebaseAuthException catch (e) {
        throw ServerException(
          message: e.message ?? 'Error Ouccured',
          statusCode: e.code,
        );
      } on ServerException {
        rethrow;
      } catch (e, s) {
        debugPrintStack(stackTrace: s);
        throw ServerException(
          message: e.toString(),
          statusCode: '505',
        );
      }
    } else {
      throw const ServerException(
        message: 'Please try again later',
        statusCode: 'Unkown Error',
      );
    }
  }

  @override
  Future<void> signUp(
      {required String email,
      required String password,
      required String fullName}) async {
    try {
      final userCred = await _authClient.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCred.user?.updateDisplayName(fullName);
      await userCred.user?.sendEmailVerification();

      // await _setUserData(_authClient.currentUser!, email);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ouccured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  @override
  Future<void> updateUser(
      {required UpdateUserAction action, dynamic userData}) async {
    try {
      switch (action) {
        case UpdateUserAction.email:
          await _authClient.currentUser?.updateEmail(userData as String);
          await _updateUserData({'email': userData});

        case UpdateUserAction.displayName:
          await _authClient.currentUser?.updateDisplayName(userData as String);
          await _updateUserData({'fullName': userData});

        case UpdateUserAction.password:
          if (_authClient.currentUser?.email == null) {
            throw const ServerException(
                message: 'User Does not exist',
                statusCode: 'Insufficient Permission');
          }
          final newData = jsonDecode(userData as String) as DataMap;
          await _authClient.currentUser?.reauthenticateWithCredential(
            EmailAuthProvider.credential(
              email: _authClient.currentUser!.email!,
              password: newData['oldPassword'] as String,
            ),
          );
          await _authClient.currentUser?.updatePassword(
            newData['newPassword'] as String,
          );
      }
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Ouccured',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrintStack(stackTrace: s);
      throw ServerException(
        message: e.toString(),
        statusCode: '505',
      );
    }
  }

  Future<DocumentSnapshot<DataMap>> _getUserData(String uid) async {
    return _cloudStoreClient.collection('users').doc(uid).get();
  }

  Future<void> _setUserData(User user, String fallbackEmail) async {
    await _cloudStoreClient.collection('users').doc(user.uid).set(
          LocalUserModel(
            uid: user.uid,
            email: user.email ?? fallbackEmail,
            fullName: user.displayName ?? '',
            remainingGen: 2,
          ).toMap(),
        );
  }

  Future<void> _updateUserData(DataMap data) async {
    await _cloudStoreClient
        .collection('users')
        .doc(_authClient.currentUser!.uid)
        .update(data);
  }
}
