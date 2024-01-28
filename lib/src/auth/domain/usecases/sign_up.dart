import 'package:equatable/equatable.dart';
import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/domain/repos/auth_repo.dart';

class SignUp extends FutureUsecaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams params) => _repo.signUp(
      email: params.email,
      password: params.password,
      username: params.username);
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.email,
    required this.password,
    required this.username,
  });

  const SignUpParams.empty()
      : email = '',
        password = '',
        username = '';

  final String email;
  final String password;
  final String username;

  @override
  List<Object?> get props => [email, password, username];
}
