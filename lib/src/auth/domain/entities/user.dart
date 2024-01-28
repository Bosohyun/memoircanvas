import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.email,
    required this.username,
    this.remainingGen,
    this.createdAt,
  });

  LocalUser.empty()
      : this(
          uid: '',
          email: '',
          username: '',
          remainingGen: 0,
          createdAt: DateTime.now(),
        );

  final String uid;
  final String email;
  final String username;
  final int? remainingGen;
  final DateTime? createdAt;

  bool get isAdmin => email == 'kbh900220@gmail.com';

  @override
  List<Object?> get props => [
        uid,
        email,
        username,
        remainingGen,
        createdAt,
      ];

  @override
  String toString() {
    return 'LocalUser{uid: $uid, email: $email,username: $username, remainingGen: $remainingGen ,}';
  }
}
