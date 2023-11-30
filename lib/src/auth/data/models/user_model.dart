import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.fullName,
    required super.numberOfJournals,
    super.profilePic,
    super.bio,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          fullName: '',
          numberOfJournals: 0,
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
            uid: map['uid'] as String,
            email: map['email'] as String,
            fullName: map['fullName'] as String,
            numberOfJournals: (map['numberOfJournals'] as num).toInt(),
            profilePic: map['profilePic'] as String?,
            bio: map['bio'] as String?);

  LocalUserModel copyWith(
      {String? uid,
      String? email,
      String? fullName,
      int? numberOfJournals,
      String? profilePic,
      String? bio,
      v}) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      numberOfJournals: numberOfJournals ?? this.numberOfJournals,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'numberOfJournals': numberOfJournals,
      'profilePic': profilePic,
      'bio': bio,
    };
  }
}
