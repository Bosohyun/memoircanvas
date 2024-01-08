import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:memoircanvas/core/enums/updata_user.dart';
import 'package:memoircanvas/src/auth/domain/entities/user.dart';
import 'package:memoircanvas/src/auth/domain/usecases/forgot_password.dart';
import 'package:memoircanvas/src/auth/domain/usecases/sign_in.dart';
import 'package:memoircanvas/src/auth/domain/usecases/sign_in_google.dart';
import 'package:memoircanvas/src/auth/domain/usecases/sign_up.dart';
import 'package:memoircanvas/src/auth/domain/usecases/update_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignInGoogle signInWithGoogle,
    required SignUp signUp,
    required ForgotPassword forgotPassword,
    required UpdateUser updateUser,
  })  : _signIn = signIn,
        _signInWithGoogle = signInWithGoogle,
        _signUp = signUp,
        _forgotPassword = forgotPassword,
        _updateUser = updateUser,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SignInWithGoogleEvent>(_signInWithGoogleHandler);

    on<SignUpEvent>(_signUpHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<UpdateUserEvent>(_updateUserHandler);
  }

  final SignIn _signIn;
  final SignInGoogle _signInWithGoogle;
  final SignUp _signUp;
  final ForgotPassword _forgotPassword;
  final UpdateUser _updateUser;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        email: event.email,
        password: event.password,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signInWithGoogleHandler(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signInWithGoogle();
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (user) => emit(SignedIn(user)),
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        fullName: event.fullName,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const EmailVerificationSent()),
    );
  }

  Future<void> _forgotPasswordHandler(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _forgotPassword(event.email);
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const ForgotPasswordSent()),
    );
  }

  Future<void> _updateUserHandler(
    UpdateUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _updateUser(
      UpdateUserParams(
        action: event.action,
        userData: event.userData,
      ),
    );
    result.fold(
      (failure) => emit(AuthError(failure.errorMessage)),
      (_) => emit(const UserUpdated()),
    );
  }
}
