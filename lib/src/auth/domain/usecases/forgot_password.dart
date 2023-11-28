import 'package:memoircanvas/core/usecases/usecases.dart';
import 'package:memoircanvas/core/utils/typedefs.dart';
import 'package:memoircanvas/src/auth/domain/repos/auth_repo.dart';

class ForgotPassword extends FutureUsecaseWithParams<void, String> {
  const ForgotPassword(this._repo);
  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String params) => _repo.forgotPassword(params);
}
