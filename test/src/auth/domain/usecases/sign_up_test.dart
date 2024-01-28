import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memoircanvas/src/auth/domain/usecases/sign_up.dart';
import 'package:mocktail/mocktail.dart';

import 'auth_repo.mock.dart';

void main() {
  late MockAuthRepo repo;
  late SignUp usecase;

  const tEmail = 'Test email';
  const tPassword = 'Test password';
  const tusername = 'Test full name';

  setUp(() {
    repo = MockAuthRepo();
    usecase = SignUp(repo);
  });

  test('should call the [AuthRepo]', () async {
    when(
      () => repo.signUp(
          email: any(named: 'email'),
          username: any(
            named: 'username',
          ),
          password: any(named: 'password')),
    ).thenAnswer((_) async => const Right(null));

    final result = await usecase(const SignUpParams(
        email: tEmail, password: tPassword, username: tusername));

    expect(result, const Right<dynamic, void>(null));

    verify(() => repo.signUp(
          email: tEmail,
          password: tPassword,
          username: tusername,
        )).called(1);

    verifyNoMoreInteractions(repo);
  });
}
