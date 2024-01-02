import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.fullName,
    this.remainingGen,
  });

  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          fullName: '',
          remainingGen: 0,
        );

  final String uid;
  final String email;
  final String fullName;
  final int? remainingGen;

  bool get isAdmin => email == 'kbh900220@gmail.com';

  @override
  List<Object?> get props => [
        uid,
        email,
        fullName,
        remainingGen,
      ];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email,fullName: $fullName, remainingGen: $remainingGen}';
  }
}
