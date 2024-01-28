import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.username,
    super.remainingGen,
    super.createdAt,
  });

  LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          username: '',
          remainingGen: 0,
          createdAt: DateTime.now(),
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          username: map['username'] as String,
          remainingGen: map['remainingGen'] as int,
          createdAt: (map['createdAt'] as Timestamp).toDate(),
        );

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? username,
    int? remainingGen,
    DateTime? createdAt,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      remainingGen: remainingGen ?? this.remainingGen,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'remainingGen': remainingGen,
      'createdAt': createdAt,
    };
  }
}
