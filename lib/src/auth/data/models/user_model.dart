import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.email,
    required super.numberOfJournals,
    required super.fullName,
    super.profilePic,
    super.bio,
  });

  const LocalUserModel.empty()
      : this(
          uid: '',
          email: '',
          numberOfJournals: 0,
          fullName: '',
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
            uid: map['uid'] as String,
            email: map['email'] as String,
            numberOfJournals: (map['numberOfJournals'] as num).toInt(),
            fullName: map['fullName'] as String,
            profilePic: map['profilePic'] as String?,
            bio: map['bio'] as String?);

  LocalUserModel copyWith({
    String? uid,
    String? email,
    String? profilePic,
    String? bio,
    int? numberOfJournals,
    String? fullName,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      numberOfJournals: numberOfJournals ?? this.numberOfJournals,
      fullName: fullName ?? this.fullName,
    );
  }

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'profilePic': profilePic,
      'bio': bio,
      'numberOfJournals': numberOfJournals,
      'fullName': fullName,
    };
  }
}
