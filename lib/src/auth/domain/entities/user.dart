import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.numberOfJournals,
    required this.fullName,
    this.profilePic,
    this.bio,
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          numberOfJournals: 0,
          fullName: '',
          profilePic: '',
          bio: '',
        );

  final String uid;
  final String email;
  final String? profilePic;
  final String? bio;
  final int numberOfJournals;
  final String fullName;

  bool get isAdmin => email == 'kbh900220@gmail.com';

  @override
  List<Object?> get props => [
        uid,
        email,
        profilePic,
        bio,
        numberOfJournals,
        fullName,
      ];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email, bio: '
        '$bio, numberOfJournals: $numberOfJournals, fullName: $fullName}';
  }
}
