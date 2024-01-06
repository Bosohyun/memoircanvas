import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/domain/entities/user.dart';
import 'package:memoircanvas/src/auth/domain/repos/auth_repo.dart';

class SignInGoogle extends FutureUsecaseWithoutParams<LocalUser> {
  const SignInGoogle(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<LocalUser> call() => _repo.signInWithGoogle();
}
